//
//  sensitiveInfo.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/10.
//

import SwiftUI

struct SusceptibleInfoView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel
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
                appState.onboardingPath.append(Onboarding.chatProfileImage)
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
//            ToolbarItem(placement: .principal) {
//                CustomProgressBar(progress: 8, total: onboardingPageCnt)
//            }
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
            makeInfoView(category: "drunking")
            makeInfoView(category: "smoking")
            makeInfoView(category: "tattoo")
            makeInfoView(category: "religion")
        }
    }
    
    func makeInfoView(category: String) -> some View {
        VStack(spacing: 10) {
            makeInfoTitle(category: category)
                .font(.pixel(20))
                .frame(maxWidth: .infinity)
            ScrollView(.horizontal) {
                makeInfoStack(category: category)
            }
        }
    }
    
    func makeInfoTitle(category: String) -> some View {
        switch category {
        case "drunking":
            return Text("음주🍺")
        case "smoking":
            return Text("흡연🚬")
        case "tattoo":
            return Text("타투🖊️")
        case "religion":
            return Text("종교🙏")
        default:
            return Text(category)
        }
    }
    
    @ViewBuilder
    func makeInfoStack(category: String) -> some View {
        switch category {
        case "drunking":
            ForEach(Array(viewModel.drunkTexts.enumerated()), id: \.element) { (index, item) in
                selectBtn(item, index, $viewModel.isDrunkButtonSelected)
            }
        case "smoking":
            ForEach(Array(viewModel.smokeTexts.enumerated()), id: \.element) { (index, item) in
                selectBtn(item, index, $viewModel.isSmokeButtonSelected)
            }
        case "tattoo":
            ForEach(Array(viewModel.tattooTexts.enumerated()), id: \.element) { (index, item) in
                selectBtn(item, index, $viewModel.isTattooButtonSelected)
            }
        case "religion":
            ForEach(Array(viewModel.religionTexts.enumerated()), id: \.element) { (index, item) in
                selectBtn(item, index, $viewModel.isReligionButtonSelected)
            }
        default:
            ForEach(Array(viewModel.religionTexts.enumerated()), id: \.element) { (index, item) in
                selectBtn(item, index, $viewModel.isReligionButtonSelected)
            }
        }
    }
    
    func selectBtn(_ word: String, _ index: Int, _ selectedArray: Binding<[Bool]>) -> some View {
        return Button(action: {
            // Binding<[Bool]>타입이므로 이 바인딩의 실제 값에 접근하기 위해서는 .wrapped프로퍼티를 사용해야함
            for i in 0...2 {
                if index == i {
                    selectedArray.wrappedValue[index] = true
                } else {
                    selectedArray.wrappedValue[i] = false
                }
            }
            
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
    SusceptibleInfoView(viewModel: AccountViewModel())
}
