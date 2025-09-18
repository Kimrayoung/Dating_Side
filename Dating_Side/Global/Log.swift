//
//  Log.swift
//  Dating_Side
//
//  Created by 김라영 on 7/22/25.
//

import Foundation
import os
import Logging 

/// 앱 전역 서브시스템 식별자
public let LogSubsystem: String = {
    Bundle.main.bundleIdentifier ?? "com.yourapp"
}()

public struct Log {
    // MARK: – iOS 14+ 전용 Logger 인스턴스
    @available(iOS 14.0, *)
    fileprivate static let debugLogger   = LoggingMacroHelper.generateLogger(category: "Debug")
    @available(iOS 14.0, *)
    fileprivate static let infoLogger    = LoggingMacroHelper.generateLogger(category: "Info")
    @available(iOS 14.0, *)
    fileprivate static let networkLogger = LoggingMacroHelper.generateLogger(category: "Network")
    @available(iOS 14.0, *)
    fileprivate static let errorLogger   = LoggingMacroHelper.generateLogger(category: "Error")
    @available(iOS 14.0, *)
    fileprivate static let traceLogger   = LoggingMacroHelper.generateLogger(category: "Trace")

    
    // MARK: – iOS 13 호환용 Legacy OSLog 인스턴스
    fileprivate static let legacyDebugLog   = OSLog(subsystem: LogSubsystem, category: "Debug")
    fileprivate static let legacyInfoLog    = OSLog(subsystem: LogSubsystem, category: "Info")
    fileprivate static let legacyNetworkLog = OSLog(subsystem: LogSubsystem, category: "Network")
    fileprivate static let legacyErrorLog   = OSLog(subsystem: LogSubsystem, category: "Error")
    fileprivate static let legacyTraceLog   = OSLog(subsystem: LogSubsystem, category: "Trace")
    
    enum Level {
        case debug, info, network, error, trace
        
        fileprivate var displayCategory: String {
            switch self {
            case .debug:   return "🟡 DEBUG"
            case .info:    return "🟠 INFO"
            case .network: return "🔵 NETWORK"
            case .error:   return "🔴 ERROR"
            case .trace:   return "🟣 TRACE"
            }
        }
        
        fileprivate var osLogType: OSLogType {
            switch self {
            case .debug:   return .debug
            case .info:    return .info
            case .network: return .default
            case .error:   return .error
            case .trace:   return .debug
            }
        }
        
        @available(iOS 14.0, *)
        fileprivate var logger: Logger {
            switch self {
            case .debug:   return Log.debugLogger
            case .info:    return Log.infoLogger
            case .network: return Log.networkLogger
            case .error:   return Log.errorLogger
            case .trace:   return Log.traceLogger
            }
        }
        
        fileprivate var legacyLog: OSLog {
            switch self {
            case .debug:   return Log.legacyDebugLog
            case .info:    return Log.legacyInfoLog
            case .network: return Log.legacyNetworkLog
            case .error:   return Log.legacyErrorLog
            case .trace:   return Log.legacyTraceLog
            }
        }
    }
    
    // MARK: – Public 전용 로깅
    static private func logPublic(
        _ message: Any,
        _ arguments: [Any],
        level: Level,
        file: String = #file,
        line: Int = #line
    ) {
        let filename = URL(fileURLWithPath: file).lastPathComponent
        let location = "[\(filename):\(line)]"
        let extra = arguments.map(String.init(describing:)).joined(separator: " ")
        let text = extra.isEmpty ? "\(message)" : "\(message) \(extra)"
        let desc = "\(location) \(level.displayCategory) \(text)"
        
        #if DEBUG
        if #available(iOS 14.0, *) {
            switch level {
            case .debug:   level.logger.debug("\(desc, privacy: .public)")
            case .info:    level.logger.info("\(desc,  privacy: .public)")
            case .network: level.logger.log("\(desc,   privacy: .public)")
            case .error:   level.logger.error("\(desc,  privacy: .public)")
            case .trace:   level.logger.trace("\(desc, privacy: .public)")
            }
        } else {
            os_log(
                "%{public}@",
                log: level.legacyLog,
                type: level.osLogType,
                desc
            )
        }
        #else
        // RELEASE 빌드: Error만
        guard level == .error else { return }
        if #available(iOS 14.0, *) {
            level.logger.error("\(desc, privacy: .public)")
        } else {
            os_log(
                "%{public}@",
                log: level.legacyLog,
                type: .error,
                desc
            )
        }
        #endif
    }
    
    // MARK: – Private 전용 로깅
    /// public 메시지 + private 인자 한 번에 처리
    static  private func logPrivate(
        _ message: Any,
        _ arguments: Any...,            // 토큰 등 민감값
        level: Level,
        file: String = #file,
        line: Int = #line
    ) {
        let filename = URL(fileURLWithPath: file).lastPathComponent
        let location = "[\(filename):\(line)]"
        let desc = "\(location) \(level.displayCategory) \(message)"
        let publicPart = String(describing: desc)
        let privatePart = arguments.map(String.init(describing:)).joined(separator: " ")
        
#if DEBUG
        if #available(iOS 14.0, *) {
            // iOS 14+ 에선 Logger API 인터폴레이션
            switch level {
            case .debug:
                level.logger.debug("\(publicPart, privacy: .public) \(privatePart, privacy: .private)")
            case .info:
                level.logger.info("\(desc, privacy: .public) \(privatePart, privacy: .private)")
            case .network:
                level.logger.log("\(publicPart, privacy: .public) \(privatePart, privacy: .private)")
            case .error:
                level.logger.error("\(publicPart, privacy: .public) \(privatePart, privacy: .private)")
            case .trace:
                level.logger.trace("\(publicPart, privacy: .public) \(privatePart, privacy: .private)")
            }
        } else {
            // iOS13~: os_log C API
            os_log(
                "%{public}@ %{private}@",
                log: legacyInfoLog,
                type: .info,
                publicPart,
                privatePart
            )
        }
#else
        // RELEASE 빌드도 동일하게 C API
        os_log(
            "%{public}@ %{private}@",
            log: level.legacyLog,
            type: .error,
            location,
            desc
        )
#endif
    }
}

public extension Log {
    // Debug
    static func debugPublic(_ message: Any, _ args: Any..., file: String = #file, line: Int = #line) {
        logPublic(message, args, level: .debug, file: file, line: line)
    }
    static func debugPrivate(_ message: Any, _ args: Any..., file: String = #file, line: Int = #line) {
        logPrivate(message, args, level: .debug, file: file, line: line)
    }
    
    // Info
    static func infoPublic(_ message: Any, _ args: Any..., file: String = #file, line: Int = #line) {
        logPublic(message, args, level: .info, file: file, line: line)
    }
    static func infoPrivate(_ message: Any, _ args: Any..., file: String = #file, line: Int = #line) {
        logPrivate(message, args, level: .info, file: file, line: line)
    }
    
    // Network
    static func networkPublic(_ message: Any, _ args: Any..., file: String = #file, line: Int = #line) {
        logPublic(message, args, level: .network, file: file, line: line)
    }
    static func networkPrivate(_ message: Any, _ args: Any..., file: String = #file, line: Int = #line) {
        logPrivate(message, args, level: .network, file: file, line: line)
    }
    
    // Error
    static func errorPublic(_ message: Any, _ args: Any..., file: String = #file, line: Int = #line) {
        logPublic(message, args, level: .error, file: file, line: line)
    }
    static func errorPrivate(_ message: Any, _ args: Any..., file: String = #file, line: Int = #line) {
        logPrivate(message, args, level: .error, file: file, line: line)
    }
    
    // Trace
    static func tracePublic(_ message: Any, _ args: Any..., file: String = #file, line: Int = #line) {
        logPublic(message, args, level: .trace, file: file, line: line)
    }
    static func tracePrivate(_ message: Any, _ args: Any..., file: String = #file, line: Int = #line) {
        logPrivate(message, args, level: .trace, file: file, line: line)
    }
}


struct Signpost {
    let log: OSLog
    let name: StaticString
    let id: OSSignpostID
    
    init(log: OSLog, name: StaticString, object: AnyObject) {
        self.log = log
        self.name = name
        // object를 기준으로 고유한 signpostID 생성
        self.id = OSSignpostID(log: log, object: object)
    }
    
    /// 인자로 넘긴 포맷·값을 함께 begin
    func begin(_ format: StaticString = "", _ args: CVarArg...) {
        if args.isEmpty {
            os_signpost(.begin, log: log, name: name, signpostID: id)
        } else {
            os_signpost(.begin, log: log, name: name, signpostID: id, format, args)
        }
    }
    
    /// 끝맺음
    func end() {
        os_signpost(.end, log: log, name: name, signpostID: id)
    }
}

extension OSLog {
    func makeSignpost(name: StaticString, object: AnyObject) -> Signpost {
        return Signpost(log: self, name: name, object: object)
    }
}


