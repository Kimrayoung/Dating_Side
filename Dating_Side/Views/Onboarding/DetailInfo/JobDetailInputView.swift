//
//  JobDetailInputView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/23.
//

import SwiftUI

struct JobDetailInputView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel
    @FocusState var focusedJobDetail: Bool
    @State var possibleNext: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            EmptyView()
                .padding(.top, 30)
            if viewModel.isOnboarding {
                CustomRounedGradientProgressBar(currentProgress: 11, total: onboardingPageCnt)
            }   
            Text("자세한 직업을 알려주면\n더 잘 어울리는 사람을\n찾을 수 있어요!")
                .font(.pixel(24))
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.top, 48)
                .padding(.leading, 20)
                .padding(.bottom, 72)
            jobInputView
            Spacer()
            Button(action: {
                appState.onboardingPath.append(Onboarding.susceptible)
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 48, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
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
                    hideKeyboard()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        appState.onboardingPath.removeLast()
                    })
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
                .frame(maxWidth: .infinity, alignment: .center)
                .overlay(
                    Rectangle()
                      .frame(height: 2)
                      .foregroundStyle(Color.gray3),
                    alignment: .bottom
                  )
                .frame(width: 228)
                .padding(.horizontal, 20)
            HStack {
                Text("최대 10자")
                    .font(.pixel(12))
                    .foregroundStyle(Color.gray3)
                Spacer()
                Text("\(viewModel.jobDetail.count)/10")
                    .font(.pixel(12))
                    .foregroundStyle(Color.gray3)
            }
            .frame(width: 228)
        })
    }
}

#Preview {
    JobDetailInputView(viewModel: AccountViewModel())
}
