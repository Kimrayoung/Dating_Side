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
    let detailLocationOption = ["강남구", "관악구", "도봉구", "은평구", "마포구", "금천구", "동작구", "광진구", "서초구", "양천구"]
    
    var body: some View {
        VStack(spacing: 0, content: {
            CustomRounedGradientProgressBar(currentScreen: 4, total: onboardingPageCnt)
                .padding(.top, 30)
            Text("어느 지역의 사람들과\n만나고 싶나요?")
                .font(.pixel(24))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 48)
            Text("가까운 사람들을 추천해드려요")
                .foregroundStyle(Color.mainColor)
                .font(.pixel(14))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 36)
            locationPicker
            Spacer()
            Button(action: {
                appState.onboardingPath.append(Onboarding.loveKeyword)
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        }) //body
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
//            ToolbarItem(placement: .principal) {
//                CustomProgressBar(progress: 2, total: onboardingPageCnt)
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
    
    var locationPicker: some View {
        HStack(spacing: 6) {
            Picker("Select an option", selection: $viewModel.locationSelectedIndex) {
                ForEach(0..<locationOption.count, id: \.self) { index in
                    Text(locationOption[index])
                        .font(.pixel(14))
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 300)
            .background(Color.white)
            Picker("Select an option", selection: $viewModel.detailLocationSelectedIndex) {
                ForEach(0..<detailLocationOption.count, id: \.self) { index in
                    Text(detailLocationOption[index])
                        .font(.pixel(14))
                        .padding()
                }
            }
            .pickerStyle(WheelPickerStyle()) // 다른 스타일로 변경 가능
            .frame(height: 300)
            .background(Color.white)
        }
        .padding(.horizontal, 24)
    }
    
    var locationPicker2: some View {
        VStack(spacing: 6) {
            List(content: {
                Section {
                    Picker("Select", selection: $viewModel.locationSelectedIndex) {
                        ForEach(0..<locationOption.count, id: \.self) { index in
                            Text(locationOption[index])
                                .font(.pixel(14))
                        }
                    }
                    .font(.pixel(10))
                    .background(Color.white)
                    Picker("Select an option", selection: $viewModel.detailLocationSelectedIndex) {
                        ForEach(0..<detailLocationOption.count, id: \.self) { index in
                            Text(detailLocationOption[index])
                                .font(.pixel(14))
                                .padding()
                        }
                    }
                    .font(.pixel(10))
                    .background(Color.white)
                }
                .listRowSeparator(.hidden)
            })
            .listStyle(PlainListStyle())
            .background(Color.white)
            .scrollContentBackground(Visibility.hidden)  // iOS 16+ 에서 사용 가능
            
        }
        .padding(.horizontal, 24)
    }
    
    var locationPicker3: some View {
        HStack(content: {
            Menu {
                Picker(selection: $viewModel.locationSelectedIndex) {
                    ForEach(0..<locationOption.count, id: \.self) { index in
                        Text(locationOption[index])
                            .padding()
                    }
                } label: {}
            } label: {
                Text("\(locationOption[viewModel.locationSelectedIndex])")
                    .font(.pixel(20))
                    .foregroundStyle(Color.blackColor)
                    .frame(width: 170, height: 42)
                    .background(Color.gray0)
                    .cornerRadius(8)
            }
            Menu {
                Picker(selection: $viewModel.detailLocationSelectedIndex) {
                    ForEach(0..<detailLocationOption.count, id: \.self) { index in
                        Text(detailLocationOption[index])
                            .padding()
                    }
                } label: {}
            } label: {
                Text("\(detailLocationOption[viewModel.detailLocationSelectedIndex])")
                    .font(.pixel(20))
                    .foregroundStyle(Color.blackColor)
                    .frame(width: 170, height: 42)
                    .background(Color.gray0)
                    .cornerRadius(8)
            }
        })
    }
    
}

#Preview {
    LocationSelectView(viewModel: OnboardingViewModel())
}
