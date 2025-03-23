//
//  NicknameInputView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/16.
//

import SwiftUI

struct NicknameInputView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var possibleNext: Bool = true
    
    var body: some View {
        VStack(content: {
            CustomRounedGradientProgressBar(currentScreen: 2, total: onboardingPageCnt)
                .padding(.top, 16)
            Text("어떤 이름으로 활동하고 싶나요?")
                .font(.pixel(24))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 73)
            Text("프로필에 사용 되며 언제든지 변경할 수 있어요")
                .foregroundStyle(Color.mainColor)
                .font(.pixel(14))
                .frame(maxWidth: .infinity, alignment: .center)
            nicknameView
                .padding(.top, 72)
            Spacer()
            Button(action: {
                appState.onboardingPath.append(Onboarding.birth)
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        })
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
//            ToolbarItem(placement: .principal) {
//                //                CustomProgressBar(progress: 1, total: onboardingPageCnt)
//                CustomRounedGradientProgressBar(currentScreen: 2, total: onboardingPageCnt)
//            }
            ToolbarItem(placement: .navigationBarLeading) {
                Image("navigationBackBtn")
            }
        })
    }
    
    var nicknameView: some View {
        VStack(spacing: 4, content: {
            ZStack(alignment: .center, content: {
                if viewModel.nicknameInput.isEmpty {
                    Text("닉네임을 입력해주세요")
                        .bottomBorder(color: Color.clear, width: 2)
                        .font(.pixel(20))
                        .foregroundStyle(Color.gray01)
                        .frame(width: 228)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                TextField("", text: $viewModel.nicknameInput)
                    .multilineTextAlignment(.center)
                    .bottomBorder(color: Color.gray3, width: 2)
                    .font(.pixel(20))
                    .frame(width: 228)
                    .frame(maxWidth: .infinity, alignment: .center)
            })
            HStack {
                Text("최대 10자")
                    .font(.pixel(12))
                    .foregroundStyle(Color.gray3)
                Spacer()
                Text("\(viewModel.nicknameInput.count)/10")
                    .font(.pixel(12))
                    .foregroundStyle(Color.gray3)
            }
            .frame(width: 228)
        })
    }
}

#Preview {
    NicknameInputView(viewModel: OnboardingViewModel())
}
