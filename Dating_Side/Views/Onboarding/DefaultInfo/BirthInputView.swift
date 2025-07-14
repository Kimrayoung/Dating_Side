//
//  BirthInputView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/16.
//

import SwiftUI

struct BirthInputView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel
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
                if viewModel.checkBirthdayComplete() {
                    hideKeyboard()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        appState.onboardingPath.append(Onboarding.height)
                    }
                }
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 48, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
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
                Button {
                    hideKeyboard()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        appState.onboardingPath.removeLast()
                    })
                } label: {
                    Image("navigationBackBtn")
                }
            }
        })
    }
    
    // Digit Input or OTP(Once Time password) Input이라고 부름
    // SwiftUI에서는 PIN Input Field, Code Input Field라고 부름
    var birthView: some View {
        HStack(spacing: 8) {
            // 년도 입력 (4자리)
            yearTextFields
            Text("년")
                .font(.pixel(14))
                .foregroundStyle(Color.blackColor)
            
            // 월 입력 (2자리)
            monthTextFields
            Text("월")
                .font(.pixel(14))
                .foregroundStyle(Color.blackColor)
            
            // 일 입력 (2자리)
            dayTextFields
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
    private func digitTextField(text: Binding<String>, focusField: BirthFocusField, onCommit: @escaping () -> Void, onBackspace: (() -> Void)? = nil, alreadyFilled: @escaping (_ text: String) -> Void) -> some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center), content: {
            if text.wrappedValue.isEmpty && focusedField != focusField {
                Text("0")
                    .bottomBorder(color: Color.clear, width: 2, bottomPadding: 5)
                    .font(.pixel(24))
                    .foregroundStyle(Color.gray01)
                    .frame(width: 16, height: 34, alignment: .center)
            }
            OneDigitTextField(
                text: text,
                isFocused: focusedField == focusField,
                onCommit: onCommit,
                alreadyFilled: alreadyFilled,
                onBackspace: {
                    if text.wrappedValue.isEmpty {
                        // 텍스트가 비어 있을 때만 이전 필드로 이동
                        if focusField.index != nil {
                            switch focusField {
                            case .year(let i) where i > 0:
                                focusedField = .year(i - 1)
                            case .month(let i) where i > 0:
                                focusedField = .month(i - 1)
                            case .day(let i) where i > 0:
                                focusedField = .day(i - 1)
                            case .month(0):
                                focusedField = .year(3) // back의 첫 번째 → front 마지막
                            case .day(0):
                                focusedField = .month(1)
                            default:
                                break
                            }
                        }
                    }
                }
            )
            .bottomBorder(color: Color.gray3, width: 2, bottomPadding: 5)
            .frame(width: 16, height: 34)
            .background(Color.clear)
            .focused($focusedField, equals: focusField)
        })
    }
    
    var yearTextFields: some View {
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
                }) { text in
                    if index == 3 {
                        viewModel.birthMonth[0] = text
                        focusedField = .month(1)
                    } else {
                        viewModel.birthYear[index + 1] = text
                        if index == 2 {
                            focusedField = .month(0)
                        } else {
                            focusedField = .year(index + 2)
                        }
                    }
                }
            } //ForEach
        } //HStack
    }
    
    var monthTextFields: some View {
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
                }) { text in
                    if index == 1 {
                        viewModel.birthDay[0] = text
                        focusedField = .day(1)
                    } else {
                        viewModel.birthMonth[1] = text
                        focusedField = .day(0)
                    }
                }
            }
        }
    }
    
    var dayTextFields: some View {
        HStack(spacing: 2) {
            ForEach(0..<2, id: \.self) { index in
                digitTextField(text: $viewModel.birthDay[index],
                               focusField: .day(index),
                               onCommit: {
                    if !viewModel.birthDay[index].isEmpty {
                        if index < 1 {
                            focusedField = .day(index + 1)
                        }
                    }
                }) { text in
                    if index == 0 {
                        viewModel.birthDay[1] = text
                        focusedField = .day(1)
                    }
                    
                }
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    BirthInputView(viewModel: AccountViewModel())
}
