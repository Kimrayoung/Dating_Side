//
//  PhoneContactViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 10/1/25.
//

import Contacts

/// 유저의 연락처 가져오기 관련
@MainActor
final class PhoneContactsViewModel: ObservableObject {
    let loadingManager = LoadingManager.shared
    let avoidanceNetwork = AvoidanceNetworkManager()

    @Published var authorizationStatus: CNAuthorizationStatus = .notDetermined
    @Published var errorMessage: String?
    
    private let store = CNContactStore()
    
    func requestAndLoad() async {
        requestContactAuthorization { [weak self] granted, error in
            Task { @MainActor in
                guard let self = self else { return }
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                // 권한없음
                if !granted {
                    self.errorMessage = "설정 > 개인정보 보호 > 연락처에서 권한을 허용해 주세요."
                    return
                }
                
                guard let originalAuthorization = self.getSavedAuthorizationStatus() else {
                    await self.saveAuthorizationStatus(granted)
                    return
                }
                
                // 권한상태 동일함
                if granted == originalAuthorization {
                    return
                } else {
                    // 권한 상태 갱신
                    self.authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
                    await self.saveAuthorizationStatus(granted)
                }
            }
        }
    }

    func requestContactAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let store = CNContactStore()
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        switch status {
        case .authorized:
            completion(true, nil)
            
        case .notDetermined:
            store.requestAccess(for: .contacts) { granted, error in
                completion(granted, error)
            }
            
        case .denied, .restricted:
            completion(false, nil)
            
        @unknown default:
            completion(false, nil)
        }
    }
    
    /// 저장된 권한 상태 가져오기
    func getSavedAuthorizationStatus() -> Bool? {
        return UserDefaults.standard.object(forKey: "PhoneContactsAuthorization") as? Bool
    }
    
    /// 저장된 권한 상태 저장하기 및 삭제&저장
    @MainActor
    func saveAuthorizationStatus(_ status: Bool) async {
        // true면 지인피하기 기능 on -> 지인들의 핸드폰 번호를 저장
        if status {
            guard let avoidanceList = self.loadContacts() else { return }
            await postAvoidanceList(avoidanceList: avoidanceList)
        } else { // false이므로 지인피하기 기능 off -> 지인들의 핸드폰 번호 삭제
            await deleteAvoidanceList()
        }
        
        UserDefaults.standard.set(status, forKey: "PhoneContactsAuthorization")
    }
    
    /// 전화번호부에 있는 전화번호들 가져오기
    private func loadContacts() -> AvoidanceList? {
        let keys: [CNKeyDescriptor] = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]
        
        // 모든 데이터를 가지고 온다
        let request = CNContactFetchRequest(keysToFetch: keys)
        request.sortOrder = .familyName
        
        var items: [String] = []
        do {
            try store.enumerateContacts(with: request) { contact, _ in
                let phones = contact.phoneNumbers.map { $0.value.stringValue }
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
                
                var phone = String(phones.joined(separator: "-"))
                guard !phones.isEmpty else { return } // 전화번호 없는 연락처 제외(원하면 제거)
                let fullName = [contact.familyName, contact.givenName].joined()
                items.append(phone)
            }
            
            return AvoidanceList(avoidanceList: items)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        return nil
    }
}


extension PhoneContactsViewModel {
    @MainActor
    func postAvoidanceList(avoidanceList: AvoidanceList) async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        do {
            let result = try await avoidanceNetwork.postAvoidanceList(avoidanceList: avoidanceList)
            
            switch result {
            case .success:
                Log.debugPublic("지인피하기 리스트 등록 성공")
            case .failure(let error):
                Log.errorPublic(error.localizedDescription)
            }
        } catch {
            Log.errorPublic(error.localizedDescription)
        }
    }
    
    @MainActor
    func deleteAvoidanceList() async {
        loadingManager.isLoading = true
        defer {
            loadingManager.isLoading = false
        }
        
        do {
            let result = try await avoidanceNetwork.deleteAvoidanceList()
            
            switch result {
            case .success:
                Log.debugPublic("지인피하기 등록된 리스트 삭제 성공")
            case .failure(let error):
                Log.errorPublic(error.localizedDescription)
            }
        } catch {
            Log.errorPublic(error.localizedDescription)
        }
    }
}
