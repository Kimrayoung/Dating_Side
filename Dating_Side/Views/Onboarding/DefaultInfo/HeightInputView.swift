//
//  HeightInputView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/17.
//

import SwiftUI

struct HeightInputView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var possibleNext: Bool = true
    
    @FocusState private var focusedField: HeightFocusField?
    @State private var showBottomModal: Bool = false
    
    var body: some View {
        VStack {
            CustomRounedGradientProgressBar(currentScreen: 4, total: onboardingPageCnt)
                .padding(.top, 16)
            Text("당신의 키를\n신중하게 선택해주세요")
                .font(.pixel(24))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 73)
            Text("생일은 이후 변경이 불가능합니다.")
                .foregroundStyle(Color.mainColor)
                .font(.pixel(14))
                .frame(maxWidth: .infinity, alignment: .center)
            heightView
                .padding(.top, 36)
            Spacer()
            Button(action: {
                showBottomModal = true
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        }
        .sheet(isPresented: $showBottomModal, content: {
            bottomModal
                .presentationDetents([.height(306)])
                .presentationCornerRadius(24)
        })
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
    
    var heightView: some View {
        HStack(spacing: 2) {
            Text("1")
                .font(.pixel(24))
                .foregroundStyle(Color.blackColor)
                .bottomBorder(color: Color.clear, width: 2, bottomPadding: 5)
                .frame(width: 16, height: 34)
            ForEach(0..<2, id: \.self) { index in
                digitTextField(text: $viewModel.height[index],
                               focusField: .height(index),
                               onCommit: {
                    if !viewModel.height[index].isEmpty {
                        if index < 1 {
                            focusedField = .height(index + 1)
                        } else {
                            // 마지막 입력 필드에서의 처리
                            hideKeyboard()
                        }
                    }
                })
            }
            Text("cm")
                .font(.pixel(14))
                .foregroundStyle(Color.blackColor)
                .padding(.leading, 6)
//                .bottomBorder(color: Color.clear, width: 2, bottomPadding: 5)
        }
        .onAppear {
            // 첫 번째 필드에 포커스
            focusedField = .height(0)
        }
        
    }
    
    private func digitTextField(text: Binding<String>, focusField: HeightFocusField, onCommit: @escaping () -> Void) -> some View {
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
    
    var bottomModal: some View {
        VStack {
            Rectangle()
                .frame(width: 53, height: 5)
                .foregroundStyle(Color.gray01)
                .cornerRadius(10)
            Text("변경 불가능한 정보들을\n마지막으로 확인 해주세요")
                .font(.pixel(16))
                .padding(.top, 32)
            Text("\(viewModel.nicknameInput) / \(getDateString()) / \(getHeightString())")
                .font(.pixel(24))
                .padding(.top, 16)
            VStack(spacing: 6){
                correctButton
                inCorrectButton
            }
            .padding(.top, 16)
        }
    }
    
    var correctButton: some View {
        Button(action: {
            showBottomModal = false
            appState.onboardingPath.append(Onboarding.locationSelect)
        }, label: {
            Text("맞아요")
                .foregroundStyle(Color.white)
                .font(.pixel(16))
                .frame(height: 48)
                .frame(maxWidth: .infinity)
        })
        
        .background(Color.mainColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .contentShape(Rectangle())
        .padding(.horizontal, 23)
    }
    
    var inCorrectButton: some View {
        Button(action: {
            showBottomModal = false
        }, label: {
            Text("다시 작성할게요")
                .foregroundStyle(Color.mainColor)
                .font(.pixel(16))
                .frame(height: 48)
                .frame(maxWidth: .infinity)
        })
        .background(Color.subColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .contentShape(Rectangle())
        .padding(.horizontal, 23)
    }
    
    // 날짜 문자열 가져오기
    func getDateString() -> String {
        let yearStr = viewModel.birthYear.joined()
        let monthStr = viewModel.birthMonth.joined()
        let dayStr = viewModel.birthDay.joined()
        
        return "\(yearStr).\(monthStr).\(dayStr)"
    }
    
    func getHeightString() -> String {
        let heightStr = viewModel.height.joined()
        
        return "\(heightStr)cm"
    }
}

#Preview {
    HeightInputView(viewModel: OnboardingViewModel())
}
