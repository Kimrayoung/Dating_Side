//
//  LocationSelectView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/18.
//

import SwiftUI

struct LocationSelectView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel
    
    @State private var possibleNext: Bool = true
    
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
                appState.onboardingPath.append(Onboarding.beforePreference)
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        }) //body
        .task {
            await viewModel.fetchAddressData(isFirstLoading: true)
        }
        
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
                ForEach(0..<viewModel.locationOption.count, id: \.self) { index in
                    Text(viewModel.locationOption[index].addrName)
                        .font(.pixel(14))
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 300)
            .background(Color.white)
            .onChange(of: viewModel.locationSelectedIndex) { oldValue, newValue in
                let selectedLocation = viewModel.locationOption[newValue]
                print(#fileID, #function, #line, "- selectedLocation: \(selectedLocation)")
                Task {
                    await viewModel.fetchAddressData(code: selectedLocation.code)
                }
            }
            Picker("Select an option", selection: $viewModel.detailLocationSelectedIndex) {
                ForEach(0..<viewModel.detailLocationOption.count, id: \.self) { index in
                    Text(viewModel.detailLocationOption[index].addrName)
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
    
}

#Preview {
    LocationSelectView(viewModel: AccountViewModel())
}
