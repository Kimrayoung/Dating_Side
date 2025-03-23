//
//  JobDetailInputView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/23.
//

import SwiftUI

struct JobDetailInputView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: OnboardingViewModel
    @FocusState var focusedJobDetail: Bool
    @State var possibleNext: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            CustomRounedGradientProgressBar(currentScreen: 4, total: onboardingPageCnt)
                .padding(.top, 16)
                .padding(.bottom, 72)
            Text("자세한 직업을 알려주면\n더 잘 어울리는 사람을\n찾을 수 있어요!")
                .font(.pixel(24))
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.leading, 20)
                .padding(.bottom, 36)
                .padding(.top, 24)
            jobInputView
            Spacer()
            Button(action: {
                appState.onboardingPath.append(Onboarding.susceptible)
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
//            ToolbarItem(placement: .principal) {
//                CustomProgressBar(progress: 3, total: onboardingPageCnt)
//            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    appState.onboardingPath.removeLast()
                } label: {
                    Image("navigationBackBtn")
                }
            }
        })
    }
    
    var jobInputView: some View {
        VStack(spacing: 4, content: {
            TextField("선택사항 입니다", text: $viewModel.jobDetail)
                .focused($focusedJobDetail)
                .multilineTextAlignment(.center)
                .bottomBorder(color: Color.gray3, width: 2)
                .font(.pixel(20))
                .frame(width: 228)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.pixel(14))
//                .frame(width: 207)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
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
    JobDetailInputView(viewModel: OnboardingViewModel())
}
