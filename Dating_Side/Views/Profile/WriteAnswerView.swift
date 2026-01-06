////
////  WriteAnswerView.swift
////  Dating_Side
////
////  Created by 김라영 on 2025/06/01.
////
//
//import SwiftUI
//
//struct WriteAnswerView: View {
//    @Binding var question: String
//    @Binding var questionNum: Int
//    @State var text: String = ""
//    @State var possibleNext: Bool = false
//    
//    var body: some View {
//        VStack(content: {
//            Text("질문 \(questionNum)")
//                .font(.pixel(12))
//                .padding(.bottom, 4)
//            Text(question)
//                .font(.pixel(20))
//                .padding(.horizontal, 55)
//                .padding(.bottom, 36)
//            answerTextEditor
//                .padding(.bottom, 16)
//            Button(action: {
//                
//            }, label: {
//                SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "다음 답변", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
//            })
//            .padding(.bottom)
//            .padding(.horizontal, 24)
//        })
//    }
//    
//    var answerTextEditor: some View {
//        ZStack(content: {
//            TextEditor(text: $text)
//                .font(.pixel(12))
//                .foregroundStyle(Color.gray01)
//                .padding([.top, .leading], 9)
//                .frame(height: 200)
//                .overlay {
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.gray01, lineWidth: 1)
//                }
//                
//            if text == "" {
//                Text("예, 아니오 등의 단답식은 프로필을 만들기 어려워요\n최대한 자세히 적어주세요")
//                    .font(.pixel(14))
//                    .foregroundStyle(Color.gray01)
//                    .padding([.top, .leading], 16)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//                    
//            }
//        })
//        .frame(height: 200)
//        .padding(.horizontal, 24)
//    }
//    
//    
//}
//
//#Preview {
//    WriteAnswerView(question: .constant("데이트날, 상대와 나의 꾸밈정도가 다르면 서운할 것 같으신가요?"), questionNum: .constant(1))
//}
