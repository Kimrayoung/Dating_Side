//
//  LoveKeywordSelectView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/18.
//

import SwiftUI

struct LoveKeywordSelectView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    let items = ["첫눈에 반했어", "애정표현을 많이", "연락은 바로", "확신이 필요해", "네 행복이 최우선", "내가 더 사랑해", "연애도 다른 재미도", "가벼운 설렘", "서로의 일상 공유", "연락 부담 없는", "더치페이 편해", "같은 가치관"]
    
    let items2 = ["정이 쌓이는 연애", "편하게 오래", "운명적인 연애", "강한 끌림", "강한 유대감", "우리 서로 취우선", "함꼐 그려가는 미래", "책임감 있는", "사랑은 배려", "조건없는 연애", "구속없는 사랑", "즐거운 연애"]
    
    @State var possibleNext: Bool = false
    
    @State var isButtonSelected: [Bool] = Array(repeating: false, count: 12)
    
    var body: some View {
        VStack(spacing: 0) {
            CustomRounedGradientProgressBar(currentScreen: 5, total: onboardingPageCnt)
                .padding(.top, 30)
            Text("러브웨이를 만나기 전\n어떤 사랑을 해왔나요?")
                .font(.pixel(24))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 48)
            Text("끌리는 키워드를 최대 7개까지 선택해주세요")
                .font(.pixel(14))
                .foregroundStyle(Color.mainColor)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 36)
            gridView
            
            Button(action: {
                appState.onboardingPath.append(Onboarding.education)
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
//            ToolbarItem(placement: .principal) {
//                CustomProgressBar(progress: 3, total: onboardingPageCnt)
//            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    appState.onboardingPath.removeLast()
                } label: {
                    Image("navigationBackBtn")
                }
            }
        })
        .onChange(of: isButtonSelected) { oldValue, newValue in
            let selectedCnt = isButtonSelected.filter { $0 == true }.count
            if selectedCnt >= 3 && selectedCnt <= 7 { possibleNext.toggle() }
        }
    }
    
    var gridView: some View {
        LazyVGrid(columns: columns, spacing: 10, content: {
            ForEach(Array(items.enumerated()), id: \.element) { (index, item) in
                selectBtn(item, index)
            }
        })
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 23)
    }
    
    func selectBtn(_ word: String, _ index: Int) -> some View {
        return Button(action: {
            isButtonSelected[index].toggle()
        }, label: { SelectButtonLabel(isSelected: $isButtonSelected[index], height: 52, text: word, backgroundColor: .white, selectedBackgroundColor: .subColor, selectedTextColor: .black ,cornerRounded: 6, strokeBorderLineWidth: 1, selectedStrokeBorderLineWidth: 2, strokeBorderLineColor: .gray01, selectedStrokeBorderColor: .mainColor) })
    }
    
}

#Preview {
    LoveKeywordSelectView(viewModel: AccountViewModel())
}
