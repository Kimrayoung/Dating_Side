//
//  CustomInputField.swift
//  Dating_Side
//
//  Created by 김라영 on 8/3/25.
//

import SwiftUI

struct CustomInputField: View {
    @Binding var text: String
    var placeholder: String = "선택사항 입니다"
    var maxCount: Int = 10
    var isFocused: FocusState<Bool>.Binding
    var font: Font = .pixel(20)
    var width: CGFloat = 228
    var horizontalPadding: CGFloat = 20

    var body: some View {
        VStack(spacing: 4) {
            TextField(placeholder, text: $text)
                .focused(isFocused)
                .multilineTextAlignment(.center)
                .bottomBorder(color: Color.gray3, width: 2)
                .font(font)
                .frame(maxWidth: .infinity, alignment: .center)
                .overlay(
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(Color.gray3),
                    alignment: .bottom
                )
                .frame(width: width)
                .padding(.horizontal, horizontalPadding)
            HStack {
                Text("최대 \(maxCount)자")
                    .font(.pixel(12))
                    .foregroundStyle(Color.gray3)
                Spacer()
                Text("\(text.count)/\(maxCount)")
                    .font(.pixel(12))
                    .foregroundStyle(Color.gray3)
            }
            .frame(width: width)
        }
    }
}
