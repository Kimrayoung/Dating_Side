//
//  JobEditView.swift
//  Dating_Side
//
//  Created by 김라영 on 8/3/25.
//

import SwiftUI

struct JobEditView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel
    @FocusState var focusedSchoolName: Bool
    @State private var possibleNext: Bool = true
    var jobType: String?
    var jobDetail: String?
    
    var body: some View {
        VStack {
            Text("직무 분야")
                .font(.pixel(20))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 32)
                .padding(.bottom, 48)
            schoolSelectView
            schoolNameView
                
            Spacer()
            Button(action: {
                if viewModel.isOnboarding == .mypageEdit {
                    guard let jobType = viewModel.makeJobType()?.type else { return }
                    
                    Task {
                        await viewModel.updateJob(jobType: jobType, jobDetail: viewModel.jobDetail)
                    }
                    
                }
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 48, text: "저장", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        }
        .task {
            if let jobType = jobType, let jobDetail = jobDetail {
                viewModel.isOnboarding = .mypageEdit
                viewModel.jobDetail = jobDetail
                await viewModel.fetchJobType(selectedJobType: jobType)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    if viewModel.isOnboarding == .onboarding || viewModel.isOnboarding == .onboardingEdit {
                        appState.onboardingPath.removeLast()
                    } else {
                        appState.myPagePath.removeLast()
                    }
                    
                } label: {
                    Image("navigationBackBtn")
                }
            }
        })
    }
    
    var schoolSelectView: some View {
        VStack {
            CustomMenuPicker(
                title: "세부 직무",
                options: viewModel.jobItmes,
                selectedIndex: $viewModel.selectedJobIndex
            )
        }
        .padding(.bottom, 48)
        .padding(.horizontal, 52)
    }
    
    var schoolNameView: some View {
        CustomInputField(
                text: $viewModel.schoolName,
                isFocused: $focusedSchoolName
            )
    }
}

#Preview {
    JobEditView(viewModel: AccountViewModel())
}
