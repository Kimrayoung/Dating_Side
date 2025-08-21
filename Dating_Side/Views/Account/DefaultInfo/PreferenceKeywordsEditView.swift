//
//  PreferenceKeywordsEditView.swift
//  Dating_Side
//
//  Created by 김라영 on 8/10/25.
//

import SwiftUI

struct PreferenceKeywordsEditView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel
    
    @State var preferenceType: PreferenceType = .before
    @State var possibleNext: Bool = true
    var beforePreferences: [String] = []
    var afterPreferences: [String] = []
    var isOnboarding: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    if preferenceType == .before {
                        return
                    } else {
                        preferenceType = .before
                    }
                } label: {
                    Image("leftWhiteArrow")
                        .frame(width: 24, height: 24)
                        .background(preferenceType == .before ? Color.init(hex: "B8B8B8") : Color.mainColor)
                        .clipShape(Circle())
                }
                VStack {
                    Text(preferenceType == .before ? "러브웨이를 만나기 전\n어떤 사랑을 해왔나요?" : "이제 러브웨이에서\n어떤 사랑을 하고 싶나요?")
                        .font(.pixel(24))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 48)
                    Text("끌리는 키워드를 최대 7개까지 선택해주세요")
                        .font(.pixel(14))
                        .foregroundStyle(Color.gray3)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 36)
                }
                Button {
                    Log.debugPublic("here")
                    if preferenceType == .before {
                        preferenceType = .after
                    } else {
                        return
                    }
                } label: {
                    Image("rightWhiteArrow")
                        .frame(width: 24, height: 24)
                        .background(preferenceType == .after ? Color.init(hex: "B8B8B8") : Color.mainColor)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 16)
            switch preferenceType {
            case .before:
                BeforePreferenceKeywordComponent(viewModel: viewModel)
            case .after:
                AfterPreferenceKeywordComponent(viewModel: viewModel)
            }
            saveButton
        }
        .task {
            if isOnboarding {
                let beforePreferences = viewModel.makeBeforePreference()
                let afterPreferences = viewModel.makeAfterPreference()
                await viewModel.fetchPreferenceType(preferenceType: .before, preferences: beforePreferences)
                await viewModel.fetchPreferenceType(preferenceType: .after, preferences: afterPreferences)
            } else {
                await viewModel.fetchPreferenceType(preferenceType: .before, preferences: beforePreferences)
                await viewModel.fetchPreferenceType(preferenceType: .after, preferences: afterPreferences)
            }
            
        }
    }
    
    var saveButton: some View {
        Button {
            if isOnboarding {
                
            } else {
                Task {
                    await viewModel.updatePreference()
                }
                
            }
        } label: {
            SelectButtonLabel(isSelected: $possibleNext, height: 48, text: "저장", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
        }

    }
    
}

#Preview {
    PreferenceKeywordsEditView(viewModel: AccountViewModel())
}
