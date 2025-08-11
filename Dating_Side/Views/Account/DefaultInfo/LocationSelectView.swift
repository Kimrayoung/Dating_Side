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
    @State private var possibleNext: Bool = false
    @State private var showCityPickerModel: Bool = false
    @State private var showDetailCityPickerModel: Bool = false
    var location: String? = nil
    
    var body: some View {
        VStack(spacing: 0, content: {
            EmptyView()
                .padding(.top, 30)
            if viewModel.isOnboarding == .onboarding {
                CustomRounedGradientProgressBar(currentProgress: 5, total: onboardingPageCnt)
            }
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
            locationView
            Spacer()
            Button(action: {
                if viewModel.isOnboarding == .onboarding {
                    if viewModel.locationSelected != nil && viewModel.detailLocationSelected != nil {
                        appState.onboardingPath.append(Onboarding.beforePreference)
                    }
                } else if viewModel.isOnboarding == .mypageEdit {
                    Task {
                        await viewModel.updateLocation()
                    }
                }
                
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 48, text: viewModel.isOnboarding == .onboarding ? "다음" : "저장", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        }) //body
        .onAppear(perform: {
            
            
        })
        .task {
            if let selectedLocationString = location?.trimmingCharacters(in: .whitespaces).components(separatedBy: "/") {
                Log.debugPublic("selectedLocationString first, last", location, selectedLocationString.first, selectedLocationString.last)
                await viewModel.fetchAddressData(selectedLocation: selectedLocationString.first)
                await viewModel.fetchAddressData(code: viewModel.locationSelected?.code, isDetailLocation: true, selectedDetailLocation: selectedLocationString.last)
            } else {
                await viewModel.fetchAddressData()
            }
            
            possibleNext = viewModel.checkLocationData()
        }
        .sheet(isPresented: $showCityPickerModel, content: {
            CityPickerModal(viewModel: viewModel, isPresented: $showCityPickerModel, title: "시/도", isDetail: false)
                .presentationDetents([.height(450)])
                .presentationCornerRadius(24)
        })
        .sheet(isPresented: $showDetailCityPickerModel, content: {
            CityPickerModal(viewModel: viewModel, isPresented: $showDetailCityPickerModel, title: "구/군", isDetail: true)
                .presentationDetents([.height(450)])
                .presentationCornerRadius(24)
        })
        .onChange(of: viewModel.locationSelected, { oldValue, newValue in
            Task {
                await viewModel.fetchAddressData(code: newValue?.code, isDetailLocation: true)
            }
            possibleNext = viewModel.checkLocationData()
        })
        .onChange(of: viewModel.detailLocationSelected, { oldValue, newValue in
            possibleNext = viewModel.checkLocationData()
        })
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    if location != nil {
                        viewModel.isOnboarding = .mypageEdit
                        appState.myPagePath.removeLast()
                    }
                    
                } label: {
                    Image("navigationBackBtn")
                }
            }
        })
    }
    
    var locationView: some View {
        HStack(spacing: 0) {
            Button {
                showCityPickerModel = true
            } label: {
                makeLocationButtonLabel(addrName: viewModel.locationSelected?.addrName ?? "시/도")
            }
            .padding(.trailing, 15)
            Button {
                showDetailCityPickerModel = true
            } label: {
                makeLocationButtonLabel(addrName: viewModel.detailLocationSelected?.addrName ?? "구/군")
            }
        }
        .padding(.horizontal, 24)
    }
    
    func makeLocationButtonLabel(addrName: String) -> some View {
        VStack {
            HStack {
                Text(addrName)
                    .font(.pixel(15))
                    .frame(maxWidth: .infinity, minHeight: 38, alignment: .leading)
                    .foregroundColor(.black)
                    .padding([.bottom, .leading], 6)
                Image(systemName: "chevron.down")
                    .foregroundColor(.black)
            }
            
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1.5)
                .foregroundStyle(Color.gray0)
        }
    }
    
    
}

#Preview {
    LocationSelectView(viewModel: AccountViewModel())
}
