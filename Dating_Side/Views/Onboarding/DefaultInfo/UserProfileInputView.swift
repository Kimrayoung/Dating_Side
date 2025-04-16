//
//  NicknameInputView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/19.
//

import SwiftUI

struct UserProfileInputView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: OnboardingViewModel
    
    let titles: [String] = ["어떻게 당신을 불러드릴까요?", "생일을 알려주세요", "키를 알려주세요"]
    let subTitles: [String] = ["10글자 이내로 입력해주세요.", "생일은 변경이 불가하니 정확히 입력해주세요", ""]
    
    @State private var possibleNext: Bool = false
    @FocusState private var focusedField: UserProfileField?
    @State private var showBirth: Bool = false
    @State private var showHeight: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            profileTitleView
            nicknameView
//            if showBirth {
//                birthView
//            }
//            if showHeight {
//                heightView
//            }
            Spacer()
            Button(action: {
                DispatchQueue.main.async {
                    if focusedField == .nickname {
                        focusedField = .birthYear
                        showBirth = true
                    }
//                    if focusedField?.focusedValue == 1 && (viewModel.birthMonth != "" && viewModel.birthYear != "" && viewModel.birthDay != "") {
//                        focusedField = .height
//                        showHeight = true
//                    }
//                    if viewModel.heightInput != "" && viewModel.birthYear != "" && viewModel.birthMonth != "" && viewModel.birthDay != "" && viewModel.nicknameInput != "" {
//                        focusedField = nil
//                        appState.onboardingPath.append(Onboarding.education)
//                    }
                }
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                CustomProgressBar(progress: 5, total: onboardingPageCnt) // 닉네임이 5번쨰
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    appState.onboardingPath.removeLast()
                } label: {
                    Image("navigationBackBtn")
                }
            }
        })
        .onChange(of: viewModel.nicknameInput) { oldValue, newValue in
            Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 10_000_000) // 0.01초 지연
                    if focusedField == .nickname && viewModel.nicknameInput.count >= 2 && viewModel.nicknameInput.count <= 10 {
                        possibleNext = true
                    }
                }
        }
//        .onAppear {
//            if viewModel.birthYear != "" && viewModel.birthMonth != "" && viewModel.birthDay != "" {
//                showBirth = true
//                showHeight = true
//            }
//        }
    }
    
    var profileTitleView: some View {
        VStack {
            Text(titles[focusedField?.focusedValue ?? 0])
                .font(.pixel(16))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            Text(subTitles[focusedField?.focusedValue ?? 0])
                .font(.pixel(10))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 24)
                .padding(.bottom, 16)
        }
    }
    
    var nicknameView: some View {
        TextField("닉네임을 입력해주세요", text: $viewModel.nicknameInput)
            .padding()
            .focused($focusedField, equals: .nickname)
            .overlay(content: {
                if focusedField == .nickname {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray01, lineWidth: 1.5)
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray01, lineWidth: 1)
                }
                
            })
            .font(.pixel(14))
            .frame(width: 207)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
    }
    
//    var birthView: some View {
//        HStack(spacing: 0) {
//            BirthTextField(
//                placeholder: "0000",
//                text: $viewModel.birthYear,
//                fieldType: .birthYear,
//                width: 70,
//                focusedField: $focusedField
//            )
//            
//            UnitLabel(text: "년")
//            
//            BirthTextField(
//                placeholder: "00",
//                text: $viewModel.birthMonth,
//                fieldType: .birthMonth,
//                width: 58,
//                focusedField: $focusedField
//            )
//            
//            UnitLabel(text: "월")
//            
//            BirthTextField(
//                placeholder: "00",
//                text: $viewModel.birthDay,
//                fieldType: .birthDay,
//                width: 58,
//                focusedField: $focusedField
//            )
//            
//            UnitLabel(text: "일")
//        }
//        .frame(height: 36)
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .padding(.top, 10)
//    }
//    
//    var heightView: some View {
//        HStack(spacing: 2) {
//            TextField("170", text: $viewModel.heightInput)
//                .keyboardType(.numberPad)
//                .padding()
//                .focused($focusedField, equals: .height)
//                .overlay(content: {
//                    if focusedField == .height {
//                        RoundedRectangle(cornerRadius: 8)
//                            .stroke(Color.gray01, lineWidth: 1.5)
//                    } else {
//                        RoundedRectangle(cornerRadius: 8)
//                            .stroke(Color.gray01, lineWidth: 1)
//                    }
//                    
//                })
//                .font(.pixel(14))
//                .frame(width: 58)
//                .padding(.leading, 20)
//                .padding(.top, 10)
//            
//            UnitLabel(text: "cm")
//                .frame(maxWidth: .infinity, alignment: .leading)
//        }
//        .frame(height: 36)
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .padding(.top, 10)
//    }

}

#Preview {
    UserProfileInputView(viewModel: OnboardingViewModel())
}
