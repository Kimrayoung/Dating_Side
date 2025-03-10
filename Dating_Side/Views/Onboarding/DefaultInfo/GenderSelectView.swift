//
//  GenderSelectView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/17.
//

import SwiftUI

struct GenderSelectView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var womanSelected: Bool = true
    @State private var manSelected: Bool = false
    @State private var possibleNext: Bool = true
    let genderOption = ["여자", "남자"]
    var body: some View {
        VStack(content: {
            Text("성별을 알려주세요")
                .font(.pixel(16))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.bottom, .horizontal], 20)
            Spacer()
//            pickerView
            genderButton
            Spacer()
            Button(action: {
                appState.onboardingPath.append(Onboarding.locationSelect)
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), storkBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal)
        })
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                CustomProgressBar(progress: 1, total: onboardingPageCnt)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Image("navigationBackBtn")
            }
        })
        .onChange(of: viewModel.genderSelectedIndex) { oldValue, newValue in
            print(#fileID, #function, #line, "- gender: \(newValue)")
            print(#fileID, #function, #line, "- oldGender: \(oldValue)")
        }
    }
    
    var genderButton: some View {
        VStack(spacing: 0) {
            Button(action: {
                womanSelected = true
                manSelected = false
                viewModel.genderSelectedIndex = 0
            }, label: {
                SelectButtonLabel(isSelected: $womanSelected, height: 36, text: "여자", backgroundColor: Color.white, selectedBackgroundColor: .subColor, textColor: Color.gray2, selectedTextColor: Color.black, cornerRounded: 8, font: .pixel(14), storkBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal)
            
            Button(action: {
                womanSelected = false
                manSelected = true
                viewModel.genderSelectedIndex = 1
            }, label: {
                SelectButtonLabel(isSelected: $manSelected, height: 36, text: "남자", backgroundColor: .white, selectedBackgroundColor: .subColor, textColor: Color.gray2, selectedTextColor: Color.black, cornerRounded: 8, font: .pixel(14), storkBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal)
        }
        
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
    GenderSelectView(viewModel: OnboardingViewModel())
}


