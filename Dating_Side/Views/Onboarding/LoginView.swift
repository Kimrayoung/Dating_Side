//
//  LoginView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = LoginViewModel()
    
    @State private var requestVerificationNumber: Bool = false
    @State private var showRequestVerificataionNumber: Bool = false
    @FocusState private var focusedField: LoginField?
    @State private var possibleNext: Bool = false
    
    var body: some View {
        VStack {
            Text("환영해요! 러브웨이 입니다.\n가입을 위해 전화번호를 입력해주세요.")
                .font(.pixel(16))
                .frame(maxWidth: .infinity, alignment: .leading)
            phoneTextField
                .frame(maxWidth: .infinity, alignment: .leading)
            if showRequestVerificataionNumber {
                Text("인증번호를 입력 해주세요.")
                    .font(.pixel(16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                verificationNumberTextField
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
            if !showRequestVerificataionNumber {
                requestVarificationNumberButton
            } else {
                nextButton
            }
        }
        .padding(.horizontal, 20)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onChange(of: viewModel.phoneNumber) { oldValue, newValue in
            if newValue != "" {
                requestVerificationNumber = true
            }
        }
        .onChange(of: viewModel.verificationNumber) { oldValue, newValue in
            if newValue != "" {
                possibleNext = true
            }
        }
    }
    
    var phoneTextField: some View {
        TextField("010-0000-0000", text: $viewModel.phoneNumber)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .padding()
            .focused($focusedField, equals: .phoneNumber)
            .overlay(content: {
                if focusedField == .phoneNumber {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray01, lineWidth: 1.5)
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray01, lineWidth: 1)
                }
                
            })
            .font(.pixel(14))
            .frame(width: 169)
            .padding(.top, 10)
    }
    
    var verificationNumberTextField: some View {
        TextField("0000", text: $viewModel.verificationNumber)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .padding()
            .focused($focusedField, equals: .verificationNumber)
            .overlay(content: {
                if focusedField == .verificationNumber {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray01, lineWidth: 1.5)
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray01, lineWidth: 1)
                }
                
            })
            .font(.pixel(14))
            .frame(width: 78)
            .padding(.top, 10)
    }
    
    var requestVarificationNumberButton: some View {
        Button(action: {
            showRequestVerificataionNumber = true
        }, label: {
            SelectButtonLabel(isSelected: $requestVerificationNumber, height: 42, text: "인증번호 요청하기", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), storkBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
        })
        .padding(.bottom)
    }
    
    var nextButton: some View {
        Button(action: {
            if viewModel.checkNumbers() {
                appState.login()
            }
        }, label: {
            SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), storkBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
        })
        .padding(.bottom)
    }
}

#Preview {
    LoginView()
}
