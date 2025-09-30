//
//  ㅣinearContenScrollView.swift
//  Dating_Side
//
//  Created by 김라영 on 9/25/25.
//

import SwiftUI

/// 답변완료시 메인 화면, 매칭뷰에서 질문 뷰 등
struct LinearContenView: View {
    /// 스크롤이 가능한지
    @Binding var possibleScroll: Bool
    @Binding var content: String
    var widthSize: CGFloat = 316
    var heightSize: CGFloat = 329
    var fontColor: Color = .black
    
    var body: some View {
        ScrollView {
            Text(content)
                .font(.pixel(16))
                .foregroundColor(fontColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 25.5)
                .padding(.vertical, 25)
        }
        .scrollDisabled(!possibleScroll)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(width: widthSize, height: heightSize)
        .padding(.horizontal, 38.5)
    }
}

#Preview {
    LinearContenView(possibleScroll: .constant(false), content: .constant(""))
}
