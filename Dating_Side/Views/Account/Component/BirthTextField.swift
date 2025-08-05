//
//  BirthTextField.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import SwiftUI

struct BirthTextField: View {
    let placeholder: String
    @Binding var text: String
    let fieldType: UserProfileField
    let width: CGFloat
    @FocusState.Binding var focusedField: UserProfileField?
    
    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(.numberPad)
            .padding(.vertical, 11.5)
            .padding(.horizontal, 13.5)
            .multilineTextAlignment(.center)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray01, lineWidth: focusedField == fieldType ? 1.5 : 1)
            })
            .font(.pixel(12))
            .frame(width: width)
            .padding(.leading, 20)
            .focused($focusedField, equals: fieldType)
    }
}

