//
//  PhoneContact.swift
//  Dating_Side
//
//  Created by 김라영 on 10/1/25.
//


struct PhoneContactItem: Identifiable, Hashable {
    let id = UUID()
    let givenName: String
    let familyName: String
    let fullName: String
    let phoneNumbers: [String]
}
