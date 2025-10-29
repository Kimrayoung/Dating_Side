//
//  ValuesListView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/26.
//

import SwiftUI

/// 가치관 목록 리스트
struct ValuesListView: View {
    var valueType: String
    var valueDataList: [Answer]
    
    
    var body: some View {
        Group {
            if valueDataList.isEmpty {
                emptyDataView
            } else {
                List(valueDataList, id:\.self) { value in
                    valueText(text: value.content)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
                .navigationTitle(valueType)
            }
        }
        .navigationTitle(valueType)
    }
    
    func valueText(text: String) -> some View {
        return Text(text)
            .font(.pixel(16))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray01, lineWidth: 1) // ✅ border 추가
            )
    }
    
    var emptyDataView: some View {
        Text("아직 데이터가 없습니다.😢\n\n일일 질문 답변을 통해 가치관 기록을 풍성하게 만들어 주시면 매칭 성공률이 올라갑니다❤️")
            .font(.pixel(16))
            .padding()
            .multilineTextAlignment(.center)
    }
}

#Preview {
    ValuesListView(valueType: "회사", valueDataList: [])
}
