//
//  BirthInputView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/16.
//

import SwiftUI

struct BirthInputView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var possibleNext: Bool = true
    
    // 포커스 상태 관리
    @FocusState private var focusedField: BirthFocusField?
    
    var body: some View {
        VStack {
            CustomRounedGradientProgressBar(currentScreen: 3, total: onboardingPageCnt)
                .padding(.top, 30)
            Text("당신의 생일을\n신중하게 선택해주세요")
                .font(.pixel(24))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 48)
            Text("생일은 이후 변경이 불가능합니다.")
                .foregroundStyle(Color.mainColor)
                .font(.pixel(14))
                .frame(maxWidth: .infinity, alignment: .center)
            birthView
                .padding(.top, 72)
            Spacer()
            Button(action: {
                appState.onboardingPath.append(Onboarding.height)
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
//                //                CustomProgressBar(progress: 1, total: onboardingPageCnt)
//                CustomRounedGradientProgressBar(currentScreen: 2, total: onboardingPageCnt)
//            }
            ToolbarItem(placement: .navigationBarLeading) {
                Image("navigationBackBtn")
            }
        })
    }
    
    // Digit Input or OTP(Once Time password) Input이라고 부름
    // SwiftUI에서는 PIN Input Field, Code Input Field라고 부름
    var birthView: some View {
        HStack(spacing: 8) {
            // 년도 입력 (4자리)
            HStack(spacing: 2) {
                ForEach(0..<4, id: \.self) { index in
                    digitTextField(text: $viewModel.birthYear[index],
                                   focusField: .year(index),
                                   onCommit: {
                        if !viewModel.birthYear[index].isEmpty {
                            if index < 3 {
                                focusedField = .year(index + 1)
                            } else {
                                focusedField = .month(0)
                            }
                        }
                    })
                }
            }
            Text("년")
                .font(.pixel(14))
                .foregroundStyle(Color.blackColor)
            
            // 월 입력 (2자리)
            HStack(spacing: 2) {
                ForEach(0..<2, id: \.self) { index in
                    digitTextField(text: $viewModel.birthMonth[index],
                                   focusField: .month(index),
                                   onCommit: {
                        if !viewModel.birthMonth[index].isEmpty {
                            if index < 1 {
                                focusedField = .month(index + 1)
                            } else {
                                focusedField = .day(0)
                            }
                        }
                    })
                }
            }
            Text("월")
                .font(.pixel(14))
                .foregroundStyle(Color.blackColor)
            
            // 일 입력 (2자리)
            HStack(spacing: 2) {
                ForEach(0..<2, id: \.self) { index in
                    digitTextField(text: $viewModel.birthDay[index],
                                   focusField: .day(index),
                                   onCommit: {
                        if !viewModel.birthDay[index].isEmpty {
                            if index < 1 {
                                focusedField = .day(index + 1)
                            } else {
                                // 마지막 입력 필드에서의 처리
                                hideKeyboard()
                            }
                        }
                    })
                }
            }
            Text("일")
                .font(.pixel(14))
                .foregroundStyle(Color.blackColor)
        }
        .onAppear {
            // 첫 번째 필드에 포커스
            focusedField = .year(0)
        }
    }
    // 각 자릿수를 위한 텍스트 필드
    private func digitTextField(text: Binding<String>, focusField: BirthFocusField, onCommit: @escaping () -> Void) -> some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center), content: {
            if text.wrappedValue.isEmpty && focusedField != focusField {
                Text("0")
                    .bottomBorder(color: Color.clear, width: 2, bottomPadding: 5)
                    .font(.pixel(24))
                    .foregroundStyle(Color.gray01)
                    .frame(width: 16, height: 34, alignment: .center)
            }
            TextField("", text: text)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.pixel(24))
                .bottomBorder(color: Color.gray3, width: 2, bottomPadding: 5)
                .frame(width: 16, height: 34)
                .focused($focusedField, equals: focusField)
                .onChange(of: text.wrappedValue, { oldValue, newValue in
                    // 숫자만 입력 가능하도록
                    if let _ = newValue.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) {
                        text.wrappedValue = String(newValue.filter { "0123456789".contains($0) })
                    }
                    
                    // 한 자리만 입력 가능하도록
                    if newValue.count > 1 {
                        text.wrappedValue = String(newValue.prefix(1))
                    }
                    
                    // 입력이 완료되면 다음 필드로 이동
                    if newValue.count == 1 {
                        onCommit()
                    }
                })
        })
    }
    
    // 키보드 숨기기
       private func hideKeyboard() {
           UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
       }
}

#Preview {
    BirthInputView(viewModel: OnboardingViewModel())
}
