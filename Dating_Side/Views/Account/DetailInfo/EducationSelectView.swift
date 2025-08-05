//
//  EducationSelectView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import SwiftUI

struct EducationSelectView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel
    
    @State var possibleNext: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            EmptyView()
                .padding(.top, 30)
            CustomRounedGradientProgressBar(currentProgress: 8, total: onboardingPageCnt)
            Text("마지막으로 공부한 곳이\n어디인가요?")
                .font(.pixel(24))
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.top, 48)
                .padding(.leading, 20)
                .padding(.bottom, 36)
                
            selectedEducationButtons
            Spacer()
            Button(action: {
                if possibleNext {
                    appState.onboardingPath.append(Onboarding.schoolName)
                }
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
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    appState.onboardingPath.removeLast()
                } label: {
                    Image("navigationBackBtn")
                }
            }
        })
        .onChange(of: viewModel.selectedEducationIndex) {
            if viewModel.selectedEducationIndex != nil {
                possibleNext = true
            }
        }
        .onAppear {
            if viewModel.selectedEducationIndex != nil {
                possibleNext = true
            }
        }
    }
    
    
    @ViewBuilder var selectedEducationButtons: some View {
        VStack(content: {
            ForEach(0..<6, id: \.self) { index in
                makeEducationButton(viewModel.education[index].korean, index)
            }
        })
        
    }
    
    func makeEducationButton(_ text: String, _ index: Int) -> some View {
        return Button {
            
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
            SelectButtonLabel(isSelected: $viewModel.isEducationButtonSelected[index], height: 52, text: text, backgroundColor: .white, selectedBackgroundColor: .subColor, textColor: .black, selectedTextColor: .black, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 1, selectedStrokeBorderLineWidth: 2,strokeBorderLineColor: .gray01, selectedStrokeBorderColor: .mainColor)
        }
        .padding(.horizontal, 46)
    }
    
    
    
}

#Preview {
    EducationSelectView(viewModel: AccountViewModel())
}
