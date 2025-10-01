//
//  PhoneContactViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 10/1/25.
//

import Contacts

@MainActor
final class ContactsViewModel: ObservableObject {
    @Published var contacts: [PhoneContactItem] = []
    @Published var authorizationStatus: CNAuthorizationStatus = .notDetermined
    @Published var errorMessage: String?
    
    private let store = CNContactStore()
    
    func requestAndLoad() {
        authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        switch authorizationStatus {
        case .authorized: // 권한있음
            loadContacts()
        case .notDetermined: // 아직 권한 요청한적 없음 -> 요청
            store.requestAccess(for: .contacts) { [weak self] granted, err in
                Task { @MainActor in
                    if let err = err { self?.errorMessage = err.localizedDescription }
                    // 요청 후 최신 권한 갱신
                    self?.authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
                    // 권한 요청해서 허용했으면 권한 가지고 오기
                    if granted { self?.loadContacts() }
                }
            }
        case .denied, .restricted:
            errorMessage = "설정 > 개인정보 보호 > 연락처에서 권한을 허용해 주세요."
        @unknown default:
            errorMessage = "알 수 없는 권한 상태입니다."
        }
    }
    
    /// 전화번호부에 있는 전화번호들 가져오기
    private func loadContacts() {
        let keys: [CNKeyDescriptor] = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]
        
        // 모든 데이터를 가지고 온다
        let request = CNContactFetchRequest(keysToFetch: keys)
        request.sortOrder = .familyName
        
        var items: [PhoneContactItem] = []
        do {
            try store.enumerateContacts(with: request) { contact, _ in
                let phones = contact.phoneNumbers.map { $0.value.stringValue }
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
                
                guard !phones.isEmpty else { return } // 전화번호 없는 연락처 제외(원하면 제거)
                let fullName = [contact.familyName, contact.givenName].joined()
                items.append(PhoneContactItem(
                    givenName: contact.givenName,
                    familyName: contact.familyName,
                    fullName: fullName.isEmpty ? contact.givenName : fullName,
                    phoneNumbers: phones
                ))
            }
            
            // 정렬 예시: 이름 기준
            self.contacts = items.sorted { $0.fullName.localizedCompare($1.fullName) == .orderedAscending }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
