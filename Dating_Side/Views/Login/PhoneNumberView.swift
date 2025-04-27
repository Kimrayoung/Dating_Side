//
//  LoginView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import SwiftUI
import Combine

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
                hideKeyboard()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    appState.loginPath.append(Login.verificationNumber)
                }
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
            frontPhoneNumebrTextFiels
            Text("-")
                .font(.pixel(24))
                .padding(.horizontal, 6)
            backPhoneNumberTextFields
        }
        .onAppear {
            // 첫 번째 필드에 포커스
            DispatchQueue.main.async {
                focusedField = .phoneNumberFront(0)
            }
            
        }
    }
    
    private func digitTextField(text: Binding<String>, focusField: PhoneNumberField, onCommit: @escaping () -> Void, onBackspace: (() -> Void)? = nil, alreadyFilled: @escaping (_ text: String) -> Void) -> some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center), content: {
            if text.wrappedValue.isEmpty && focusedField != focusField {
                Text("0")
                    .bottomBorder(color: Color.clear, width: 2, bottomPadding: 1)
                    .font(.pixel(24))
                    .foregroundStyle(Color.gray01)
                    .frame(width: 16, height: 34, alignment: .center)
            }
            OneDigitTextField(
                text: text,
                isFocused: focusedField == focusField,
                onCommit: onCommit,
                alreadyFilled: alreadyFilled,
                onBackspace: {
                    if text.wrappedValue.isEmpty {
                        // 텍스트가 비어 있을 때만 이전 필드로 이동
                        if focusField.index != nil {
                            switch focusField {
                            case .phoneNumberFront(let i) where i > 0:
                                focusedField = .phoneNumberFront(i - 1)
                            case .phoneNumberBack(let i) where i > 0:
                                focusedField = .phoneNumberBack(i - 1)
                            case .phoneNumberBack(0):
                                focusedField = .phoneNumberFront(3) // back의 첫 번째 → front 마지막
                            default:
                                break
                            }
                        }
                    }
                }
            )
            .bottomBorder(color: Color.gray3, width: 2, bottomPadding: 5)
            .frame(width: 16, height: 34)
            .background(Color.clear)
            .focused($focusedField, equals: focusField)

        })
    }
    
    // 키보드 숨기기
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // 8자리 중에 앞부분
    var frontPhoneNumebrTextFiels: some View {
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
            }, alreadyFilled: { text in
                if index == 3 {
                    viewModel.phoneBackNumber[0] = text
                    focusedField = .phoneNumberBack(1)
                } else {
                    viewModel.phoneFrontNumber[index + 1] = text
                    if index == 2 {
                        focusedField = .phoneNumberBack(0)
                    } else {
                        focusedField = .phoneNumberFront(index + 2)
                    }
                }
            })
        }
    }
    
    // 8자리 중에 뒷부분
    var backPhoneNumberTextFields: some View {
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
                    }
                }
            }, alreadyFilled: { text in
                if index < 2 {
                    viewModel.phoneBackNumber[index + 1] = text
                    focusedField = .phoneNumberBack(index + 2)
                } else {
                    if index == 2 {
                        viewModel.phoneBackNumber[index + 1] = text
                        focusedField = .phoneNumberBack(index + 1)
                    }
                    if (viewModel.checkPhoneNumbers()) {
                        possibleNext = true
                    }
                }
            })
        }
    }
}

#Preview {
    PhoneNumberView(viewModel: LoginViewModel())
}
