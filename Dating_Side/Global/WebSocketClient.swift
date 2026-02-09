//
//  WebSocketManager.swift
//  Dating_Side
//
//  Created by 김라영 on 8/24/25.
//

import Foundation

private enum StompCommand: String {
    case stomp = "STOMP"
    case connect = "CONNECT", connected = "CONNECTED", message = "MESSAGE"
    case send = "SEND", subscribe = "SUBSCRIBE", unsubscribe = "UNSUBSCRIBE"
    case disconnect = "DISCONNECT", error = "ERROR"
    case receipt = "RECEIPT"
}

private struct StompFrame {
    let command: StompCommand
    var headers: [String: String] = [:]
    var body: String = ""
    
    func build() -> String {
        var lines = [command.rawValue]
        for (k, v) in headers {
            lines.append("\(k):\(v)")
        }
        lines.append("") // 헤더와 바디 사이 빈 줄
        lines.append(body)
        return lines.joined(separator: "\n") + "\0" // 널 종결자
    }
    
    static func parse(_ raw: String) -> (StompCommand, [String:String], String)? {
        // 널 종결자 제거
        let cleanRaw = raw.hasSuffix("\0") ? String(raw.dropLast()) : raw
        
        guard let split = cleanRaw.range(of: "\n\n") else { return nil }
        let headerPart = String(cleanRaw[..<split.lowerBound])
        let body = String(cleanRaw[split.upperBound...])
        
        let headerLines = headerPart.components(separatedBy: "\n")
        guard let cmdStr = headerLines.first,
              let cmd = StompCommand(rawValue: cmdStr) else { return nil }
        
        var headers: [String:String] = [:]
        for line in headerLines.dropFirst() {
            if let idx = line.firstIndex(of: ":") {
                let k = String(line[..<idx])
                let v = String(line[line.index(after: idx)...])
                headers[k] = v
            }
        }
        return (cmd, headers, body)
    }
}

actor WebSocketClient {
    enum State { case idle, connecting, connected, disconnected, failed(Error) }
    
    private(set) var state: State = .idle
    
    private let session: URLSession
    private let endpointURL: URL
    private var task: URLSessionWebSocketTask?
    
    // STOMP 보조 상태
    private var buffer = ""
    private var subIdSeed = 0
    private var subscribedRoomId: String?
    private var pingTimer: Timer?
    private var reconnectAttempts = 0
    private var isManuallyClosed = false
    private var isStompConnected = false
    private var roomId: String = ""
    private var stompWaiters: [CheckedContinuation<Void, Never>] = []
    
    // 외부 스트림 (ChatMessage)
    private var continuation: AsyncStream<ChatMessage>.Continuation?
    
    lazy var messages: AsyncStream<ChatMessage> = {
        AsyncStream { continuation in self.continuation = continuation }
    }()
    
    private let wsDelegate = WSDelegate()
    
    init(endpoint: String, jwt: String? = nil, roomId: String) {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 0  // 무제한
        config.timeoutIntervalForResource = 0  // 무제한
        config.allowsCellularAccess = true
        config.allowsConstrainedNetworkAccess = true
        config.allowsExpensiveNetworkAccess = true
        
        var headers: [AnyHashable: Any] = [:]
        if let jwt {
            headers["Authorization"] = "Bearer \(jwt)"
        }
        headers["Origin"] = "https://donvolo.shop"
        headers["Sec-WebSocket-Protocol"] = "v12.stomp,v11.stomp,v10.stomp"
        config.httpAdditionalHeaders = headers
        
        self.session = URLSession(configuration: config, delegate: wsDelegate, delegateQueue: .main)
        self.endpointURL = URL(string: endpoint)!.forcingWebSocketScheme()
        self.roomId = roomId
    }
    
    /// STOMP CONNECTED 될 때까지 suspend
    func waitUntilStompConnected() async {
        if isStompConnected { return }
        await withCheckedContinuation { cont in
            stompWaiters.append(cont)
        }
    }
    
    private func resumeStompWaiters() {
        let waiters = stompWaiters
        stompWaiters.removeAll()
        for w in waiters { w.resume() }
    }
    
    // MARK: Public
    func connect(jwt: String? = nil, hostHeader: String = "donvolo.shop") async {
        switch state {
        case .idle, .disconnected, .failed: break
        default: return
        }
        
        isManuallyClosed = false
        isStompConnected = false
        state = .connecting
        
        let url = endpointURL
        print("🔗 Connecting to: \(url.absoluteString)")
        
        let t = session.webSocketTask(
            with: url,
            protocols: ["v12.stomp", "v11.stomp", "v10.stomp", "stomp"]
        )
        task = t
        t.resume()
        
        // WebSocket 연결 대기 (타임아웃 처리)
        do {
            try await withTimeout(seconds: 10) {
                try await self.wsDelegate.waitUntilOpen()
            }
            print("✅ WebSocket opened successfully")
        } catch {
            print("❌ WebSocket open failed: \(error)")
            state = .failed(error)
            return
        }
        
        // STOMP CONNECT 프레임 전송 (STOMP 명령어 대신 CONNECT 사용)
        let headers: [String: String] = [
            "accept-version": "1.0,1.1,1.2",
            "host": hostHeader,
            "heart-beat": "0,0"  // 일단 하트비트 비활성화
        ]
        
        let connectFrame = StompFrame(command: .connect, headers: headers, body: "")
        await sendRaw(connectFrame.build())
        print("📤 STOMP CONNECT sent")
        
        Task { await receiveLoop() }
    }
    
    func subscribe(roomId: String) async {
        guard task != nil, isStompConnected else {
            print("⚠️ Cannot subscribe: not connected")
            Log.debugPublic("task checking", task)
            Log.debugPublic("isStompConnected", isStompConnected)
            return
        }
        
        subscribedRoomId = roomId
        subIdSeed += 1
        let f = StompFrame(
            command: .subscribe,
            headers: [
                "id": "sub-\(subIdSeed)",
                "destination": "/user/sub/chat/room/\(roomId)",
                "ack": "auto"
            ],
            body: ""
        )
        await sendRaw(f.build())
        print("📤 SUBSCRIBE sent for room: \(roomId)")
    }
    
    func sendMessage(_ message: SocketMessage) async throws {
        guard isStompConnected else {
            throw NSError(domain: "STOMP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not connected"])
        }
        
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(message)
        let body = String(data: data, encoding: .utf8) ?? "{}"
        
        let f = StompFrame(
            command: .send,
            headers: [
                "destination": "/pub/chat/send",
                "content-type": "application/json;charset=UTF-8",
                "content-length": "\(body.utf8.count)"
            ],
            body: body
        )
        await sendRaw(f.build())
        print("📤 Message sent: \(message.content)")
    }
    
    func disconnect() async {
        isManuallyClosed = true
        isStompConnected = false
        stopPing()
        
        // STOMP DISCONNECT 프레임 전송
        if task != nil {
            let disconnectFrame = StompFrame(command: .disconnect, headers: [:], body: "")
            await sendRaw(disconnectFrame.build())
            
            // 잠시 대기 후 연결 종료
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1초
        }
        
        task?.cancel(with: .goingAway, reason: nil)
        task = nil
        state = .disconnected
        continuation?.finish()
    }
    
    // MARK: Internal
    private func sendRaw(_ text: String) async {
        guard let t = task else { return }
        do {
            try await t.send(.string(text))
            print("📤 Sent success: \(text.replacingOccurrences(of: "\0", with: "\\0"))")
        } catch {
            print("❌ Send error: \(error)")
        }
    }
    
    private func receiveLoop() async {
        guard let t = task else { return }
        state = .connected
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        while !isManuallyClosed {
            do {
                let msg = try await t.receive()
                switch msg {
                case .string(let text):
                    buffer += text
                    await processBuffer(decoder: decoder)
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        buffer += text
                        await processBuffer(decoder: decoder)
                    }
                @unknown default:
                    break
                }
            } catch {
                await handleError(error)
                break
            }
        }
    }
    
    private func processBuffer(decoder: JSONDecoder) async {
        while let nullIndex = buffer.firstIndex(of: "\0") {
            let frameString = String(buffer[..<nullIndex])
            buffer.removeSubrange(buffer.startIndex...nullIndex)
            
            if !frameString.isEmpty {
                print("📥 Received: \(frameString)")
                await handleRawFrame(frameString, decoder: decoder)
            }
        }
    }
    
    private func handleRawFrame(_ raw: String, decoder: JSONDecoder) async {
        guard let (cmd, headers, body) = StompFrame.parse(raw) else {
            print("❌ Failed to parse STOMP frame: \(raw)")
            return
        }
        
        print("📥 STOMP \(cmd.rawValue): headers=\(headers), body=\(body.prefix(100))")
        
        switch cmd {
        case .connected:
            isStompConnected = true
            print("✅ STOMP Connected!")
            startPing()
            resumeStompWaiters()
            
        case .message:
            if let data = body.data(using: .utf8),
               let chat = try? decoder.decode(ChatPayload.self, from: data) {
                let chatData = ChatMessage(
                    id: UUID(),
                    content: chat.content,
                    sender: chat.sender,
                    timestamp:  Date().toIntArray// 수신 시각으로 채움
                )
                continuation?.yield(chatData)
                
                Task { @MainActor in
                    NotificationCenter.default.post(
                        name: NSNotification.Name("NewChatMessageReceived"),
                        object: nil,
                        userInfo: ["message": chatData]
                    )
                    print("📢 실시간 메시지 알림 전송 완료!") // 로그 확인용
                }
                
            } else {
                print("❌ Failed to decode message: \(body)")
            }
            
        case .error:
            print("❌ STOMP Error: \(body)")
            let errorMessage = ChatMessage(
                content: "서버 오류: \(body)", sender: 0,
                timestamp: []
            )
            continuation?.yield(errorMessage)
            
        case .receipt:
            print("📋 Receipt received: \(headers)")
            
        default:
            print("📥 Unhandled STOMP command: \(cmd.rawValue)")
        }
    }
    
    // MARK: Ping / Reconnect
    
    private func startPing() {
        stopPing()
        // WebSocket ping을 더 자주 전송하여 연결 유지
        pingTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
            Task { [weak self] in
                guard let self, let t = await self.task else { return }
                t.sendPing { error in
                    if let error {
                        print("❌ Ping error: \(error)")
                        Task { await self.handleError(error) }
                    } else {
                        print("🏓 Ping sent successfully")
                    }
                }
            }
        }
        if let pingTimer {
            RunLoop.main.add(pingTimer, forMode: .common)
        }
    }
    
    private func stopPing() {
        pingTimer?.invalidate()
        pingTimer = nil
    }
    
    private func handleError(_ error: Error) async {
        print("❌ Connection error: \(error)")
        stopPing()
        isStompConnected = false
        state = .failed(error)
        guard !isManuallyClosed else { return }
        
        reconnectAttempts += 1
        let maxAttempts = 5
        if reconnectAttempts <= maxAttempts {
            let delay = min(pow(2.0, Double(reconnectAttempts)), 30.0) // 최대 30초
            print("🔄 Reconnecting in \(delay) seconds (attempt \(reconnectAttempts)/\(maxAttempts))")
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            state = .disconnected
            await connect()
            if let room = subscribedRoomId {
                await subscribe(roomId: room)
            }
        } else {
            print("❌ Max reconnection attempts reached")
            state = .disconnected
            continuation?.finish()
        }
    }
}

private extension URL {
    func forcingWebSocketScheme() -> URL {
        var c = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        switch c.scheme?.lowercased() {
        case "http":  c.scheme = "ws"
        case "https": c.scheme = "wss"
        case nil:     c.scheme = "wss"
        default: break
        }
        return c.url!
    }
}

// 타임아웃 헬퍼 함수
private func withTimeout<T>(
    seconds: TimeInterval,
    operation: @escaping () async throws -> T
) async throws -> T {
    try await withThrowingTaskGroup(of: T.self) { group in
        group.addTask {
            try await operation()
        }
        
        group.addTask {
            try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            throw TimeoutError()
        }
        
        let result = try await group.next()!
        group.cancelAll()
        return result
    }
}

private struct TimeoutError: Error, LocalizedError {
    var errorDescription: String? {
        return "Operation timed out"
    }
}

final class WSDelegate: NSObject, URLSessionWebSocketDelegate, URLSessionTaskDelegate {
    private var openCont: CheckedContinuation<Void, Error>?
    private var isOpened = false
    
    func waitUntilOpen() async throws {
        if isOpened { return } // 이미 열린 경우
        
        try await withCheckedThrowingContinuation { cont in
            if isOpened {
                cont.resume()
            } else {
                self.openCont = cont
            }
        }
    }
    
    func urlSession(_ s: URLSession, webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol proto: String?) {
        print("✅ WebSocket opened, subprotocol: \(proto ?? "nil")")
        isOpened = true
        openCont?.resume()
        openCont = nil
    }
    
    func urlSession(_ s: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error {
            print("❌ WebSocket handshake failed: \(error)")
            isOpened = false
            openCont?.resume(throwing: error)
            openCont = nil
        }
    }
    
    func urlSession(_ s: URLSession, webSocketTask: URLSessionWebSocketTask,
                    didCloseWith code: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        let reasonStr = reason.flatMap { String(data: $0, encoding: .utf8) } ?? "-"
        print("🔌 WebSocket closed: \(code.rawValue) - \(reasonStr)")
        isOpened = false
        
        // 1002는 Protocol Error
        if code.rawValue == 1002 {
            print("⚠️ Protocol Error - 서버가 STOMP 프레임을 거부했습니다")
        }
    }
}
