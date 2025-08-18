//
//  EducationEditView.swift
//  Dating_Side
//
//  Created by 김라영 on 8/3/25.
//

import SwiftUI

struct EducationEditView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel
    @FocusState var focusedSchoolName: Bool
    @State private var possibleNext: Bool = true
    var educationType: String? = nil
    var schoolName: String? = nil
    
    var body: some View {
        VStack {
            Text("수정할 최종학력를 알려주세요")
                .font(.pixel(20))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 32)
                .padding(.bottom, 48)
            schoolSelectView
            schoolNameView
            Spacer()
            Button(action: {
                if viewModel.isOnboarding == .mypageEdit {
                    Task {
                        await viewModel.updateEducation()
                    }
                } else if viewModel.isOnboarding == .onboardingEdit {
                    appState.onboardingPath.removeLast()
                }
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 48, text: "저장", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        }
        .task {
            if let educationType = educationType, let schoolName = schoolName {
                viewModel.isOnboarding = .mypageEdit
                viewModel.schoolName = schoolName
                viewModel.setEducation(selectedEducation: educationType)
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
                title: "학교 이름",
                options: viewModel.education,
                selectedIndex: $viewModel.selectedEducationIndex
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
    EducationEditView(viewModel: AccountViewModel())
}
