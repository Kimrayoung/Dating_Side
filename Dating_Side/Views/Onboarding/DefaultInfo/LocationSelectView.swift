//
//  LocationSelectView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/18.
//

import SwiftUI

struct LocationSelectView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: OnboardingViewModel
    
    @State private var possibleNext: Bool = true
    let locationOption = ["서울특별시", "경기도", "강원도", "제주도", "전라남도", "전라북도", "경상남도", "경상북도", "충청남도", "충청북도"]
    
    var body: some View {
        VStack(spacing: 0, content: {
            Text("내가 현재 있는 곳은 어디인가요?")
                .font(.pixel(16))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
            Text("가까운 곳에 있는 사람과 더 쉽게 연결될 수 있어요.")
                .font(.pixel(10))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
            Spacer()
            Picker("Select an option", selection: $viewModel.locationSelectedIndex) {
                ForEach(0..<locationOption.count, id: \.self) { index in
                    Text(locationOption[index])
                        .font(.pixel(14))
                        .padding()
                }
            }
            .pickerStyle(WheelPickerStyle()) // 다른 스타일로 변경 가능
            .frame(height: 500)
            .background(Color.white)
            .cornerRadius(10)
            .padding()
//            CustomPicker(selectedIndex: $selectedIndex,
//                         items: locationOption.enumerated().map { index, value in
//                CustomPickerItem(id: index, value: value)
//            },
//                         itemHeight: 40, menuHeightMultiplier: 12) // 여기서 높이 조절
//            .padding(20)
            Spacer()
            Button(action: {
                appState.onboardingPath.append(Onboarding.loveKeyword)
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .blackColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), storkBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal)
        }) //body
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                CustomProgressBar(progress: 2, total: onboardingPageCnt)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    appState.onboardingPath.removeLast()
                } label: {
                    Image("navigationBackBtn")
                }
            }
        })
    }
}

#Preview {
    LocationSelectView(viewModel: OnboardingViewModel())
}
