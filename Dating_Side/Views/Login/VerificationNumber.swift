//
//  VerificationNumber.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/17.
//

import SwiftUI

struct VerificationNumber: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: LoginViewModel
    @FocusState private var focusedField: VerificationNumberField?
    @State private var possibleNext: Bool = false
    
    var body: some View {
        VStack(content: {
            Spacer()
            Text("\(viewModel.getPhoneNumber())로 전송된\n인증번호를 입력해주세요")
                .font(.pixel(20))
                .multilineTextAlignment(.center)
                .padding(.bottom, 36)
            verificationNumberView
            Spacer()
            Button(action: {
                if viewModel.checkVerificationNumber() {
                    print(#fileID, #function, #line, "- 여기")
                    appState.login()
                }
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "러브웨이 시작하기", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        })
    }
    
    var verificationNumberView: some View {
        HStack(spacing: 16) {
            ForEach(0..<4, id: \.self) { index in
                digitTextField(text: $viewModel.verificationNumber[index],
                               focusField: .verificationNumber(index),
                               onCommit: {
                    if !viewModel.verificationNumber[index].isEmpty {
                        if index < 3 {
                            focusedField = .verificationNumber(index + 1)
                        } else {
                            // 마지막 입력 필드에서의 처리
                            possibleNext = true
                            hideKeyboard()
                        }
                    }
                })
            }
        }
        .onAppear {
            // 첫 번째 필드에 포커스
            focusedField = .verificationNumber(0)
        }
    }
    
    private func digitTextField(text: Binding<String>, focusField: VerificationNumberField, onCommit: @escaping () -> Void) -> some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center), content: {
            if text.wrappedValue.isEmpty && focusedField != focusField {
                Text("0")
                    .bottomBorder(color: Color.clear, width: 2, bottomPadding: 1)
                    .font(.pixel(24))
                    .foregroundStyle(Color.gray01)
                    .frame(width: 16, height: 34, alignment: .center)
            }
            TextField("", text: text)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.pixel(24))
                .bottomBorder(color: Color.gray3, width: 2, bottomPadding: 5)
                .frame(width: 16, height: 34)
                .focused($focusedField, equals: focusField)
                .onChange(of: text.wrappedValue, { oldValue, newValue in
                    // 숫자만 입력 가능하도록
                    if let _ = newValue.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) {
                        text.wrappedValue = String(newValue.filter { "0123456789".contains($0) })
                    }
                    
                    // 한 자리만 입력 가능하도록
                    if newValue.count > 1 {
                        text.wrappedValue = String(newValue.prefix(1))
                    }
                    
                    // 입력이 완료되면 다음 필드로 이동
                    if newValue.count == 1 {
                        onCommit()
                    }
                })
        })
    }
    
    // 키보드 숨기기
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    VerificationNumber(viewModel: LoginViewModel())
}
