//
//  LoginView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import SwiftUI

struct PhoneNumberView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: LoginViewModel
    
    @FocusState private var focusedField: PhoneNumberField?
    @State private var possibleNext: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            WelcomeText()
                .font(.pixel(20))
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .padding(.bottom, 36)
            phoneNumberView
            Spacer()
            Button(action: {
                appState.loginPath.append(Login.verificationNumber)
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "인증번호 받기", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        }
        .padding(.horizontal, 20)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
    
    var firstNumber: some View {
        HStack(spacing: 6, content: {
            makeFirstNumber("0")
            makeFirstNumber("1")
            makeFirstNumber("0")
        })
    }
    
    func makeFirstNumber(_ num: String) -> some View {
        return Text(num)
            .font(.pixel(24))
            .foregroundStyle(Color.blackColor)
            .bottomBorder(color: Color.clear, width: 2, bottomPadding: 1)
            .frame(width: 16, height: 34)
    }
    
    var phoneNumberView: some View {
        HStack(spacing: 2) {
            firstNumber
            Text("-")
                .font(.pixel(24))
                .padding(.horizontal, 6)
            ForEach(0..<4, id: \.self) { index in
                digitTextField(text: $viewModel.phoneFrontNumber[index],
                               focusField: .phoneNumberFront(index),
                               onCommit: {
                    if !viewModel.phoneFrontNumber[index].isEmpty {
                        if index < 3 {
                            focusedField = .phoneNumberFront(index + 1)
                        } else {
                            // 마지막 입력 필드에서의 처리
                            focusedField = .phoneNumberBack(0)
                        }
                    }
                })
            }
            Text("-")
                .font(.pixel(24))
                .padding(.horizontal, 6)
            ForEach(0..<4, id: \.self) { index in
                digitTextField(text: $viewModel.phoneBackNumber[index],
                               focusField: .phoneNumberBack(index),
                               onCommit: {
                    if !viewModel.phoneBackNumber[index].isEmpty {
                        if index < 3 {
                            focusedField = .phoneNumberBack(index + 1)
                        } else {
                            if (viewModel.checkPhoneNumbers()) {
                                possibleNext = true
                            }
                            
                            // 마지막 입력 필드에서의 처리
                            hideKeyboard()
                        }
                    }
                })
            }
        }
        .onAppear {
            // 첫 번째 필드에 포커스
            focusedField = .phoneNumberFront(0)
        }
        
    }
    
    private func digitTextField(text: Binding<String>, focusField: PhoneNumberField, onCommit: @escaping () -> Void) -> some View {
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
    PhoneNumberView(viewModel: LoginViewModel())
}
