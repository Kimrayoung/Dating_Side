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
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack(spacing: 0) {
            EmptyView()
                .padding(.top, 30)
            if viewModel.isOnboarding {
                CustomRounedGradientProgressBar(currentProgress: 12, total: onboardingPageCnt)
            }
            Text("당신의 라이프스타일을 알려주세요")
                .font(.pixel(20))
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.top, 48)
                .padding(.leading, 20)
                .padding(.bottom, 48)
                
            infoView
            Spacer()
            Button(action: {
                if possibleNext {
                    appState.onboardingPath.append(Onboarding.chatProfileImage)
                }
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 48, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
        }
        .task {
            await viewModel.fetchLifeStyle()
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
                    appState.onboardingPath.removeLast()
                } label: {
                    Image("navigationBackBtn")
                }
            }
        })
    }
    
    var infoView: some View {
        VStack(spacing: 32) {
            makeInfoView(category: "drinking")
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
        case "drinking":
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
        Group {
            if let contentList = viewModel.lifeStyleList[category] {
                let boolBinding = Binding<[Bool]>( //Binding<[Bool>] -> [Bool]배열을 바인딩 한다
                    get: { // viewModel.lifeStyleButtonList[category]에서 값을 꺼냄
                        viewModel.lifeStyleButtonList[category] ?? Array(repeating: false, count: contentList.count)
                    },
                    set: { newValue in // 뷰에서 버튼을 클릭하면 내부에서 바인딩 배열이 변경된 배열로 바뀜
                        viewModel.lifeStyleButtonList[category] = newValue
                    }
                )
                
                HStack(spacing: 4) {
                    ForEach(Array(contentList.enumerated()), id: \.1) { index, item in
                        selectBtn(item, index, boolBinding)
                    }
                }
            } else {
                EmptyView()
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
            possibleNext = viewModel.susceptibleInfoCompleteChecking()
        }, label: {
            SelectButtonLabel(
                isSelected: selectedArray[index],
                height: 48,
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
            .frame(width: (screenWidth - 49 - 8) / 3)
        })
    }
    
}

#Preview {
    SusceptibleInfoView(viewModel: AccountViewModel())
}
