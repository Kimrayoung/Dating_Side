//
//  ProflieEditView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/30.
//

import SwiftUI

struct ProflieEditView: View {
    var body: some View {
        VStack(spacing: 0) {
            ArrowNextRow(label: "프로필 사진, 자기소개", subTitle: nil) {
                
            }
            .padding(.bottom, 32)
            .padding(.top, 16)
            ArrowNextRow(label: "지역 서울시 강남구", subTitle: nil) {
                
            }
            .padding(.bottom, 32)
            ArrowNextRow(label: "학력 서울대학교", subTitle: nil) {
                
            }
            .padding(.bottom, 32)
            ArrowNextRow(label: "직업 IOS 개발자", subTitle: nil) {
                
            }
            .padding(.bottom, 32)
            ArrowNextRow(label: "라이프 스타일", subTitle: "음주, 흡연, 타투, 종교") {
                
            }
            .padding(.bottom, 32)
            Spacer()
        }
        .navigationTitle("프로필 편집")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                saveButton
            }
        })
    }

    var saveButton: some View {
        Button(action: {
            
        }, label: {
            Text("저장")
                .font(.pixel(14))
                .foregroundStyle(Color.mainColor)
        })
    }

}

#Preview {
    ProflieEditView()
}
