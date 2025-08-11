//
//  MatchingAnswerView.swift
//  Dating_Side
//
//  Created by 김라영 on 7/29/25.
//

import SwiftUI

struct MatchingAnswerView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject private var viewModel: QuestionViewModel
    @FocusState private var isFocused: Bool
    @State private var answer: String = ""
    @State private var possibleNext: [Int : Bool] = [:]
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    if viewModel.isFirstQuestion {
                        return
                    } else {
                        viewModel.nextQuestion()
                    }
                } label: {
                    Image("leftWhiteArrow")
                        .frame(width: 24, height: 24)
                        .background(viewModel.isFirstQuestion ? Color.init(hex: "B8B8B8") : Color.mainColor)
                        .clipShape(Circle())
                }
                VStack {
                    Text("질문 \(viewModel.currentQuestion.id)")
                        .font(.pixel(12))
                    Text(viewModel.currentQuestion.text)
                        .font(.pixel(20))
                        .padding(.horizontal)
                }
                Button {
                    if viewModel.isFirstQuestion {
                        return
                    } else {
                        viewModel.previousQuestion()
                    }
                } label: {
                    Image("rightWhiteArrow")
                        .frame(width: 24, height: 24)
                        .background(viewModel.isLastQuestion ? Color.init(hex: "B8B8B8") : Color.mainColor)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 53)
            .padding(.bottom, 36)
            answerTextEditor
            nextAnswerButton
        }
        .onAppear(perform: {
            isFocused = true
        })
        .onChange(of: viewModel.currentIndex, { _, newValue in
            answer = viewModel.answers[newValue] ?? ""
        })
        .onChange(of: answer, { oldValue, newValue in
            if newValue == "" {
                possibleNext[viewModel.currentIndex] = false
            } else {
                possibleNext[viewModel.currentIndex] = true
            }
        })
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    if viewModel.currentIndex == 0 {
                        appState.matchingPath.removeLast()
                    } else {
                        viewModel.currentIndex -= 1
                    }
                } label: {
                    Image("navigationBackBtn")
                }
            }
        })
    }
    
    var answerTextEditor: some View {
        ZStack(content: {
            TextEditor(text: $answer)
                .focused($isFocused)
                .submitLabel(.done)
                .font(.pixel(12))
                .foregroundStyle(Color.blackColor)
                .padding([.top, .leading], 9)
                .frame(height: 200)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray01, lineWidth: 1)
                }
            
            if answer == "" {
                Text("예, 아니오 등의 단답식은 프로필을 만들기 어려워요\n최대한 자세히 적어주세요.")
                    .font(.pixel(12))
                    .foregroundStyle(Color.gray01)
                    .padding([.top, .leading], 16)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
            }
        })
        .onSubmit {
            if answer == "" {
                possibleNext[viewModel.currentIndex] = false
                return
            }
            viewModel.answers[viewModel.currentIndex] = answer
            possibleNext[viewModel.currentIndex - 1] = true
            
            if viewModel.isLastQuestion {
                isFocused = false
            } else {
                viewModel.currentIndex += 1
            }
        }
        .frame(height: 200)
        .padding(.horizontal, 24)
    }
    
    var nextAnswerButton: some View {
        Button {
            if answer == "" {
                return
            }
            viewModel.answers[viewModel.currentIndex] = answer
            
            if viewModel.isLastQuestion {
                Task {
                    await viewModel.postTodayQuetionAnswers()
                }
                appState.matchingPath.append(Matching.questionComplete)
            } else {
                viewModel.currentIndex += 1
            }
        } label: {
            SelectButtonLabel(isSelected: Binding(
                get: { possibleNext[viewModel.currentIndex] ?? false },  // nil일 때 false로 반환
                set: { possibleNext[viewModel.currentIndex] = $0 }     // 값 업데이트
            ), height: 42, text: "다음답변", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
        }
        .padding(.horizontal, 24)

    }
}

#Preview {
    MatchingAnswerView()
}
