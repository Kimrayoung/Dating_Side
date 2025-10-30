//
//  PhoneContactViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 10/1/25.
//

import Contacts
import UIKit

/// 유저의 연락처 가져오기 관련
@MainActor
final class PhoneContactsViewModel: ObservableObject {
    let loadingManager = LoadingManager.shared
    let avoidanceNetwork = AvoidanceNetworkManager()

    @Published var authorizationStatus: CNAuthorizationStatus = .notDetermined
    @Published var errorMessage: String?
    
    private let store = CNContactStore()
    private var isProcessing = false
    private let contactQueue = DispatchQueue(label: "com.dating.contacts", qos: .userInitiated)
    
    func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // 권한만 확인, 로드하지 않음
    func checkAuthorizationOnly() async {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        self.authorizationStatus = status
        
        // 이미 저장된 권한 상태 확인
        let savedStatus = getSavedAuthorizationStatus()
        
        switch status {
        case .authorized, .limited:
            if savedStatus != true {
                UserDefaults.standard.set(true, forKey: "PhoneContactsAuthorization")
            }
        case .denied, .restricted:
            if savedStatus == true {
                UserDefaults.standard.set(false, forKey: "PhoneContactsAuthorization")
            }
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    // ✅ 버튼 클릭 시에만 호출
    func requestAndLoad() async {
        guard !isProcessing else {
            Log.debugPublic("이미 처리 중입니다")
            return
        }
        
        isProcessing = true
        defer { isProcessing = false }
        
        let granted = await requestContactAuthorization()
        self.authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        if granted {
            await loadContacts()
        } else {
            UserDefaults.standard.set(false, forKey: "PhoneContactsAuthorization")
        }
    }
    
    /// 권한 요청
    func requestContactAuthorization() async -> Bool {
        let status = CNContactStore.authorizationStatus(for: .contacts)

        switch status {
        case .authorized, .limited:
            return true

        case .notDetermined:
            do {
                let granted = try await store.requestAccess(for: .contacts)
                return granted
            } catch {
                return false
            }

        case .denied, .restricted:
            return false

        @unknown default:
            return false
        }
    }

    
    // 백그라운드에서 연락처 로드 -> 로그되면 연락처 서버로 전송
    func loadContacts() async {
        // 백그라운드 스레드에서 실행
        let avoidanceList = await loadContactsInBackground()
        guard let avoidanceList = avoidanceList else { return }
        Log.debugPublic("avoidanceList 확인", avoidanceList)
        await postAvoidanceList(avoidanceList: avoidanceList)
    }
    
    // ✅ 백그라운드 스레드에서 연락처 로드 (블로킹 작업)
    private func loadContactsInBackground() async -> AvoidanceList? {
        return await withCheckedContinuation { continuation in
            contactQueue.async { [weak self] in
                guard let self = self else {
                    continuation.resume(returning: nil)
                    return
                }
                
                let result = self.loadContactsOptimized()
                
                Task { @MainActor in
                    continuation.resume(returning: result)
                }
            }
        }
    }
    
    func getSavedAuthorizationStatus() -> Bool? {
        return UserDefaults.standard.object(forKey: "PhoneContactsAuthorization") as? Bool
    }
    
    /// 010 번호만 표준 포맷(010-####-####)으로 정규화
    func normalizeKoreanMobile(_ raw: String) -> String? {
        var cleaned = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // +82 → 0 치환
        if cleaned.hasPrefix("+82") {
            cleaned = "0" + cleaned.dropFirst(3)
        }
        // 숫자만 추출
        cleaned = cleaned.filter { $0.isNumber }
        
        // 길이/접두 체크
        guard cleaned.count == 11 else { return nil }
        guard cleaned.hasPrefix("010") else { return nil }
        
        // 포맷팅
        let head = cleaned.prefix(3)
        let mid  = cleaned.dropFirst(3).prefix(4)
        let tail = cleaned.suffix(4)
        return "\(head)-\(mid)-\(tail)"
    }

    /// 연락처 로딩 + 정규화
    private func loadContactsOptimized() -> AvoidanceList? {
        // 권한 방어 (authorized 아닐 때 바로 종료)
        guard CNContactStore.authorizationStatus(for: .contacts) == .authorized else {
            Log.debugPublic("연락처 권한 없음: authorized가 아님")
            return nil
        }
        
        let keys: [CNKeyDescriptor] = [
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]
        let request = CNContactFetchRequest(keysToFetch: keys)
        request.unifyResults = true
        
        var normalizedSet = Set<String>()   // 중복 제거
        var contactCount = 0
        let maxContacts = 10_000            // 안전 한계
        
        do {
            try store.enumerateContacts(with: request) { contact, stop in
                contactCount += 1
                if contactCount > maxContacts {
                    stop.pointee = true
                    Log.debugPublic("연락처 로드 한계 도달: \(maxContacts)개")
                    return
                }
                
                for phoneNumber in contact.phoneNumbers {
                    if let formatted = normalizeKoreanMobile(phoneNumber.value.stringValue) {
                        normalizedSet.insert(formatted)
                    }
                    // normalize 실패한 번호는 버림
                }
            }
            
            // 결정적 결과를 위해 정렬
            let result = Array(normalizedSet).sorted()
            Log.debugPublic("✅ 연락처 로드 완료: \(result.count)개 / 총 \(contactCount)개 연락처")
            return AvoidanceList(avoidanceList: result)
            
        } catch {
            Log.errorPublic("❌ 연락처 로딩 실패: \(error.localizedDescription)")
            return nil
        }
    }

}

extension PhoneContactsViewModel {
    @MainActor
    func postAvoidanceList(avoidanceList: AvoidanceList) async {
        loadingManager.isLoading = true
        defer { loadingManager.isLoading = false }
        
        do {
            let result = try await avoidanceNetwork.postAvoidanceList(avoidanceList: avoidanceList)
            
            switch result {
            case .success:
                Log.debugPublic("✅ 지인피하기 리스트 등록 성공: \(avoidanceList.avoidanceList.count)개")
            case .failure(let error):
                Log.errorPublic("❌ 지인피하기 등록 실패: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
            }
        } catch {
            Log.errorPublic("❌ postAvoidanceList 예외: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func deleteAvoidanceList() async {
        loadingManager.isLoading = true
        defer { loadingManager.isLoading = false }
        
        do {
            let result = try await avoidanceNetwork.deleteAvoidanceList()
            
            switch result {
            case .success:
                Log.debugPublic("✅ 지인피하기 리스트 삭제 성공")
            case .failure(let error):
                Log.errorPublic("❌ 지인피하기 삭제 실패: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
            }
        } catch {
            Log.errorPublic("❌ deleteAvoidanceList 예외: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        }
    }
}
