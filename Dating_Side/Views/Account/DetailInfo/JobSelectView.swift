//
//  JobSelectView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/23.
//

import SwiftUI

struct JobSelectView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    @State var possibleNext: Bool = false
    
    var body: some View {
        VStack {
            EmptyView()
                .padding(.top, 30)
            CustomRounedGradientProgressBar(currentProgress: 10, total: onboardingPageCnt)
            Text("어떤 일을 하고 계신가요?")
                .font(.pixel(24))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 56)
                .padding(.bottom, 72)
            
            gridView
            
            Button(action: {
                if possibleNext {
                    appState.onboardingPath.append(Onboarding.jobDetail)
                }
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 48, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        }
        .task {
            await viewModel.fetchJobType()
        }
        .onAppear(perform: {
            if viewModel.selectedJobIndex != nil {
                possibleNext = true
            }
        })
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
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10, content: {
                ForEach(Array(viewModel.jobItmes.enumerated()), id: \.element) { (index, item) in
                    selectBtn(item.korean, index)
                }
            })
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 31.5)
    }
    
    func selectBtn(_ word: String, _ index: Int) -> some View {
        return Button(action: {
            possibleNext = true
            for idx in 0..<viewModel.jobItmes.count {
                if idx == index {
                    viewModel.isJobButtonSelected[idx] = true
                } else {
                    viewModel.isJobButtonSelected[idx] = false
                }
                viewModel.selectedJobIndex = index
            }
        }, label: { SelectButtonLabel(isSelected: $viewModel.isJobButtonSelected[index], height: 52, text: word, backgroundColor: .white, selectedBackgroundColor: .subColor, selectedTextColor: .black ,cornerRounded: 6, strokeBorderLineWidth: 1, selectedStrokeBorderLineWidth: 2, strokeBorderLineColor: .gray01, selectedStrokeBorderColor: .mainColor) })
    }
}

#Preview {
    JobSelectView(viewModel: AccountViewModel())
}
