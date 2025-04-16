//
//  sensitiveInfo.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/10.
//

import SwiftUI

struct SusceptibleInfoView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: OnboardingViewModel
    
    var drunkTexts: [String] = ["언제든지!", "가볍게 즐겨요", "안마셔요"]
    var smokeTexts: [String] = ["흡연자에요", "가끔 피워요", "비흡연자에요"]
    var tattooTexts: [String] = ["있어요", "관심이 있어요", "없어요"]
    var religionTexts: [String] = ["있어요", "관심이 있어요", "없어요"]
    
    
    @State var possibleNext: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            CustomRounedGradientProgressBar(currentScreen: 4, total: onboardingPageCnt)
                .padding(.top, 30)
                .padding(.bottom, 48)
            Text("당신의 라이프스타일을 알려주세요")
                .font(.pixel(20))
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.leading, 20)
                .padding(.bottom, 48)
                
            infoView
            Spacer()
            Button(action: {
                
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
        }
        .padding(.horizontal, 24)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                CustomProgressBar(progress: 8, total: onboardingPageCnt)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    
                } label: {
                    Image("navigationBackBtn")
                }
            }
        })
    }
    
    var infoView: some View {
        VStack(spacing: 32) {
            drunkInfo
            smokeInfo
            tattooInfo
            religionInfo
        }
    }
    
    var drunkInfo: some View {
        VStack(spacing: 10) {
            Text("음주🍺")
                .font(.pixel(20))
                .frame(maxWidth: .infinity)
            HStack(spacing: 7) {
                ForEach(Array(drunkTexts.enumerated()), id: \.element) { (index, item) in
                    selectBtn(item, index, $viewModel.isDrunkButtonSelected)
                }
            }
        }
    }
    
    var smokeInfo: some View {
        VStack(spacing: 10) {
            Text("흡연🚬")
                .font(.pixel(20))
                .frame(maxWidth: .infinity)
            HStack(spacing: 7) {
                ForEach(Array(smokeTexts.enumerated()), id: \.element) { (index, item) in
                    selectBtn(item, index, $viewModel.isSmokeButtonSelected)
                }
            }
        }
    }
    
    var tattooInfo: some View {
        VStack(spacing: 10) {
            Text("타투🖊️")
                .font(.pixel(20))
                .frame(maxWidth: .infinity)
            HStack(spacing: 7) {
                ForEach(Array(tattooTexts.enumerated()), id: \.element) { (index, item) in
                    selectBtn(item, index, $viewModel.isTattooButtonSelected)
                }
            }
        }
    }
    
    var religionInfo: some View {
        VStack(spacing: 10) {
            Text("종교🙏")
                .font(.pixel(16))
                .frame(maxWidth: .infinity)
            HStack(spacing: 7) {
                ForEach(Array(religionTexts.enumerated()), id: \.element) { (index, item) in
                    selectBtn(item, index, $viewModel.isReligionButtonSelected)
                }
            }
        }
    }
    
    func selectBtn(_ word: String, _ index: Int, _ selectedArray: Binding<[Bool]>) -> some View {
        return Button(action: {
            // Binding<[Bool]>타입이므로 이 바인딩의 실제 값에 접근하기 위해서는 .wrapped프로퍼티를 사용해야함
            selectedArray.wrappedValue[index].toggle()
        }, label: {
            SelectButtonLabel(
                isSelected: selectedArray[index],
                height: 42,
                text: word,
                backgroundColor: .white,
                selectedBackgroundColor: .subColor,
                selectedTextColor: .black,
                cornerRounded: 8,
                strokeBorderLineWidth: 1,
                selectedStrokeBorderLineWidth: 2,
                strokeBorderLineColor: Color.gray01,
                selectedStrokeBorderColor: Color.mainColor
            )
        })
    }
    
}

#Preview {
    SusceptibleInfoView(viewModel: OnboardingViewModel())
}
