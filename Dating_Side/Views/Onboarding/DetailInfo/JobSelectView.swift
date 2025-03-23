//
//  JobSelectView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/23.
//

import SwiftUI

struct JobSelectView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: OnboardingViewModel
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    let items = ["전문직/기업", "연구/교육", "IT/개발", "의료/복지", "디자인/크리에이티브", "미디어/예술", "금융/법률", "영업/서비스", "기술/생산", "은퇴", "아직 학생이에요", "기타"]
    @State var possibleNext: Bool = false
    
    var body: some View {
        VStack {
            CustomRounedGradientProgressBar(currentScreen: 9, total: onboardingPageCnt)
                .padding(.top, 16)
            Text("어떤 일을 하고 계신가요?")
                .font(.pixel(24))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 36)
            
            gridView
            
            Button(action: {
                appState.onboardingPath.append(Onboarding.jobDetail)
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
    
    var gridView: some View {
        LazyVGrid(columns: columns, spacing: 10, content: {
            ForEach(Array(items.enumerated()), id: \.element) { (index, item) in
                selectBtn(item, index)
            }
        })
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 23)
    }
    
    func selectBtn(_ word: String, _ index: Int) -> some View {
        return Button(action: {
            viewModel.isJobButtonSelected[index].toggle()
            possibleNext = true;
        }, label: { SelectButtonLabel(isSelected: $viewModel.isJobButtonSelected[index], height: 52, text: word, backgroundColor: .white, selectedBackgroundColor: .subColor, selectedTextColor: .black ,cornerRounded: 6, strokeBorderLineWidth: 1, selectedStrokeBorderLineWidth: 2, strokeBorderLineColor: .gray01, selectedStrokeBorderColor: .mainColor) })
    }
}

#Preview {
    JobSelectView(viewModel: OnboardingViewModel())
}
