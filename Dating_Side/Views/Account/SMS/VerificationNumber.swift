//
//  VerificationNumber.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/17.
//

import SwiftUI

struct VerificationNumber: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: SMSViewModel
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
            
            HStack {
                ZStack {
                    HStack{
                        Image("timer")
                        Text(viewModel.timerString)
                            .font(.rounded(18))
                            .foregroundStyle(Color(hex: "FF7878"))
                    }
                    .opacity(viewModel.timerRunning ? 1 : 0)
                    
                    Button {
                        viewModel.resendVerficationNumber()
                    } label: {
                        HStack{
                            Image("resend")
                            Text("재전송")
                                .font(.rounded(18))
                                .foregroundStyle(Color.black)
                        }
                    }
                    .opacity(viewModel.timerRunning ? 0 : 1)
                    .disabled(viewModel.vertificationBlock)
                }
            }
            .padding(.top, 16)
            
            Spacer()
            
            //인증번호가 다름
            Text("인증번호를 다시 확인해주세요.")
                .font(.rounded(12))
                .foregroundStyle(Color(hex: "FA104F"))
                .padding(.bottom, 8)
                .opacity(viewModel.vertificationFail == true ? 1 : 0)
            
            Button(action: {
                if !viewModel.checkVerificationNumber() {
                    return
                }
                hideKeyboard()
                Task{
                    let result = await viewModel.verifySMSCode()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if result {
                            appState.onboardingPath.append(Onboarding.genderSelect)
                        }
                    }
                }
                
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "러브웨이 시작하기", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        })
        .onAppear {
            Task {
                viewModel.checkSMSBlock()
                if !viewModel.vertificationBlock{
                    await viewModel.requestVerifiactionNumber()
                }
                
                if viewModel.verificationNumber.count == 4 {
                    focusedField = .verificationNumber(viewModel.verificationNumber.count - 1)
                }
                
                await viewModel.timerStart()
            }
        }
        .onChange(of: viewModel.verificationNumber) { oldValue, newValue in
            possibleNext = viewModel.checkVerificationNumber()
        }
        .customAlert(isPresented: $viewModel.vertificationBlock, title: "반복 인증 실패", message: "5회 이상 발송으로 12시간뒤 다시 인증이 가능합니다.", primaryButtonText: "확인", primaryButtonAction: {
            viewModel.timerRunning = false
        })
    }
    
    var verificationNumberView: some View {
        HStack(spacing: 16) {
            ForEach(0..<4, id: \.self) { index in
                digitTextField(text: $viewModel.verificationNumber[index],
                               focusField: .verificationNumber(index),
                               onCommit: {
                    if !viewModel.phoneFrontNumber[index].isEmpty {
                        if index < 3 {
                            focusedField = .verificationNumber(index + 1)
                        } else {
                            // 마지막 입력 필드에서의 처리
                            if (viewModel.checkVerificationNumber()) {
                                possibleNext = true
                            }
                        }
                    }
                }, alreadyFilled: { text in
                    if index < 2 {
                        viewModel.verificationNumber[index + 1] = text
                        focusedField = .verificationNumber(index + 2)
                    } else {
                        if index == 2 {
                            viewModel.verificationNumber[index + 1] = text
                            focusedField = .verificationNumber(index + 1)
                        }
                        if (viewModel.checkVerificationNumber()) {
                            possibleNext = true
                        }
                    }
                })
            }
        }
        
    }
    
    private func digitTextField(text: Binding<String>, focusField: VerificationNumberField, onCommit: @escaping () -> Void, onBackspace: (() -> Void)? = nil, alreadyFilled: @escaping (_ text: String) -> Void) -> some View {
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
                            case .verificationNumber(let i) where i > 0:
                                focusedField = .verificationNumber(i - 1)
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
    
}

#Preview {
    VerificationNumber(viewModel: SMSViewModel())
}
