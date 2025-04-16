//
//  EducationSelectView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import SwiftUI

struct EducationSelectView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: OnboardingViewModel
    
    var items = ["고등학교", "대학교 재학 중", "대학 졸업", "석사", "박사", "기타"]
    @State var possibleNext: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            CustomRounedGradientProgressBar(currentScreen: 4, total: onboardingPageCnt)
                .padding(.top, 30)
                .padding(.bottom, 48)
            Text("마지막으로 공부한 곳이\n어디인가요?")
                .font(.pixel(16))
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.leading, 20)
                .padding(.bottom, 72)
                
            selectedEducationButtons
            Spacer()
            Button(action: {
                appState.onboardingPath.append(Onboarding.schoolName)
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
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    appState.onboardingPath.removeLast()
                } label: {
                    Image("navigationBackBtn")
                }
            }
        })
        .onChange(of: viewModel.selectedEducationIndex) { oldValue, newValue in
            print(#fileID, #function, #line, "- newvalue:\(newValue)")
        }
    }
    
    
    @ViewBuilder var selectedEducationButtons: some View {
        VStack(content: {
            ForEach(0..<6, id: \.self) { index in
                makeEducationButton(items[index], index)
            }
        })
        
    }
    
    func makeEducationButton(_ text: String, _ index: Int) -> some View {
        return Button {
            possibleNext = true
            for idx in 0..<viewModel.isEducationButtonSelected.count {
                if idx == index {
                    viewModel.isEducationButtonSelected[idx] = true
                } else {
                    viewModel.isEducationButtonSelected[idx] = false
                }
            }
            viewModel.isEducationButtonSelected[index] = true
            viewModel.selectedEducationIndex = index
        } label: {
            SelectButtonLabel(isSelected: $viewModel.isEducationButtonSelected[index], height: 42, text: text, backgroundColor: .white, selectedBackgroundColor: .subColor, textColor: .black, selectedTextColor: .black, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 1, selectedStrokeBorderLineWidth: 2,strokeBorderLineColor: .gray01, selectedStrokeBorderColor: .mainColor)
        }
        .padding(.horizontal, 46)
    }
    
    
    
}

#Preview {
    EducationSelectView(viewModel: OnboardingViewModel())
}
