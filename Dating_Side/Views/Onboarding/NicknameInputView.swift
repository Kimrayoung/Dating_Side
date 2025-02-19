//
//  NicknameInputView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/19.
//

import SwiftUI

struct NicknameInputView: View {
    @State private var nicknameInput: String = ""
    
    @State private var birthYear: Int = 2000
    @State private var birthMonth: Int = 10
    @State private var birthDay: Int = 03
    @State var selection = Date()
    @State private var possibleNext: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("어떻게 당신을 불러드릴까요?")
                .font(.pixel(16))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            Text("10글자 아내로 입력해주세요.")
                .font(.pixel(10))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 24)
                .padding(.bottom, 16)
            
            TextField("닉네임을 입력해주세요", text: $nicknameInput)
                .padding()
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray01, lineWidth: 1)
                })
                .font(.pixel(14))
                .frame(width: 207)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            Picker("", selection: $selection) {
                ForEach(2000...2020, id: \.self) {
                    Text(String($0))
                }
            }
            .pickerStyle(InlinePickerStyle())
            Spacer()
            Button(action: {}, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .blackColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), storkBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal)
        }
    }
}

#Preview {
    NicknameInputView()
}
