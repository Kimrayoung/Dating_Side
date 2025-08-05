//
//  GenderSelectView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/17.
//

import SwiftUI

struct GenderSelectView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel
    @State private var womanSelected: Bool = true
    @State private var manSelected: Bool = false
    @State private var possibleNext: Bool = true
    @State private var showAlert: Bool = false
    let genderOption = ["여자", "남자"]
    
    var body: some View {
        VStack(spacing: 0, content: {
            EmptyView()
                .padding(.top, 30)
            if viewModel.isOnboarding == .onboarding {
                CustomRounedGradientProgressBar(currentProgress: 1, total: onboardingPageCnt)
                    .padding(.bottom, 48)
            }
            Text("당신의 성별을\n신중하게 선택해주세요")
                .font(.pixel(24))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
            Text("성별은 이후 변경이 불가능합니다")
                .foregroundStyle(Color.mainColor)
                .font(.pixel(16))
                .frame(maxWidth: .infinity, alignment: .center)
//            pickerView
            genderButton
                .padding(.top, 72)
            Spacer()
            Button(action: {
                appState.onboardingPath.append(Onboarding.nickname)
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 48, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        })
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
//                CustomProgressBar(progress: 1, total: onboardingPageCnt)
//                CustomRounedGradientProgressBar(currentProgress: 1, total: onboardingPageCnt)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    showAlert = true
                }, label: {
                    Image("navigationBackBtn")
                })
            }
        })
        .customAlert(isPresented: $showAlert, title: "회원가입을 중단하고\n시작화면으로 나갈까요?", message: "나가면 입력한 정보가 저장되지 않아요", primaryButtonText: "나가기", primaryButtonAction: {}, secondaryButtonText: "취소", secondaryButtonAction: {appState.onboardingPath.removeLast()})
    }
    
    var genderButton: some View {
        VStack(spacing: 6) {
            Button(action: {
                womanSelected = true
                manSelected = false
                viewModel.genderSelectedIndex = 0
            }, label: {
                SelectButtonLabel(isSelected: $womanSelected, height: 52, text: "여자", backgroundColor: Color.white, selectedBackgroundColor: .subColor, textColor: Color.gray2, selectedTextColor: Color.black, cornerRounded: 8, font: .pixel(20), strokeBorderLineWidth: 1, selectedStrokeBorderLineWidth: 2, strokeBorderLineColor: Color.gray01, selectedStrokeBorderColor: Color.mainColor)
            })
            
            Button(action: {
                womanSelected = false
                manSelected = true
                viewModel.genderSelectedIndex = 1
            }, label: {
                SelectButtonLabel(isSelected: $manSelected, height: 52, text: "남자", backgroundColor: .white, selectedBackgroundColor: .subColor, textColor: Color.gray2, selectedTextColor: Color.black, cornerRounded: 8, font: .pixel(20), strokeBorderLineWidth: 1, selectedStrokeBorderLineWidth: 2, strokeBorderLineColor: Color.gray01, selectedStrokeBorderColor: Color.mainColor)
            })
        }
        .padding(.horizontal, 46)
        
    }
    
    var pickerView: some View {
        Picker("Select an option", selection: $viewModel.genderSelectedIndex) {
            ForEach(0..<genderOption.count, id: \.self) { index in  // 인덱스를 순회
                Text(genderOption[index])
                    .font(.pixel(14))
                    .padding()
            }
        }
        .pickerStyle(WheelPickerStyle()) // 다른 스타일로 변경 가능
        .frame(height: 130)
        .background(Color.white)
        .cornerRadius(10)
        .padding()
    }
}

#Preview {
    GenderSelectView(viewModel: AccountViewModel())
}


