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
    @FocusState var focusedSchoolName: Bool
    @State private var showSchoolName: Bool = false
    
    var items = ["고등학교", "대학교 재학 중", "대학 졸업"]
    @State var possibleNext: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("마지막으로 공부한 곳은 어디신가요?")
                .font(.pixel(16))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .padding(.bottom, 16)
            if !showSchoolName {
                beforeSelectedEducationButton
            } else {
                afterSelectedEducationButton
                schoolNameInput
            }
            Spacer()
            Button(action: {
//                appState.onboardingPath.append(Onboarding.userProfile)
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), storkBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                CustomProgressBar(progress: 6, total: onboardingPageCnt)
            }
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
    
    var beforeSelectedEducationButton: some View {
        VStack(spacing: 8) {
            ForEach(Array(items.enumerated()), id: \.element) { (index, item) in
                makeEducationButton(item, index)
            }
        }
    }
    
    @ViewBuilder var afterSelectedEducationButton: some View {
        if let educationIndex = viewModel.selectedEducationIndex {
            makeEducationButton(items[educationIndex], educationIndex)
        } else { EmptyView() }
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
            showSchoolName = true
        } label: {
            SelectButtonLabel(isSelected: $viewModel.isEducationButtonSelected[index], height: 42, text: text, backgroundColor: .white, selectedBackgroundColor: .subColor, textColor: .black, selectedTextColor: .black,cornerRounded: 8, font: .pixel(14), storkBorderLineWidth: 1, selectedStrokeBorderLineWidth: 2)
        }
        .padding(.horizontal, 20)
    }
    
    var schoolNameInput: some View {
        VStack {
            Text("학교 이름을 알려주면\n더 잘 어울리는 사람을 찾을 수 있어요!")
                .font(.pixel(14))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .padding(.bottom, 12)
                .padding(.top, 24)
            TextField("선택사항 입니다", text: $viewModel.schoolName)
                .padding()
                .focused($focusedSchoolName)
                .overlay(content: {
                    if focusedSchoolName {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray01, lineWidth: 1.5)
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray01, lineWidth: 1)
                    }
                    
                })
                .font(.pixel(14))
//                .frame(width: 207)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
        }
    }
    
}

#Preview {
    EducationSelectView(viewModel: OnboardingViewModel())
}
