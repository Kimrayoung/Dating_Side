//
//  SchoolNameInput.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/23.
//

import SwiftUI

struct SchoolNameInput: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel
    @FocusState var focusedSchoolName: Bool
    @State var possibleNext: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            EmptyView()
                .padding(.top, 30)
            CustomRounedGradientProgressBar(currentProgress: 9, total: onboardingPageCnt)
            Text("학교 이름을 알려주면\n더 잘 어울리는 사람을\n찾을 수 있어요!")
                .font(.pixel(24))
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.top, 48)
                .padding(.leading, 20)
                .padding(.bottom, 72)
                
            schoolNameView
            Spacer()
            Button(action: {
                appState.onboardingPath.append(Onboarding.job)
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
    
    var schoolNameView: some View {
        CustomInputField(
                text: $viewModel.schoolName,
                isFocused: $focusedSchoolName
            )
    }
    
}

#Preview {
    SchoolNameInput(viewModel: AccountViewModel())
}
