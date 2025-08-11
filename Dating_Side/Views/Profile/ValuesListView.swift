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
        List(valueDataList, id:\.self) { value in
            valueText(text: value.content)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
        .listStyle(PlainListStyle())
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
}

#Preview {
    ValuesListView(valueType: "회사", valueDataList: [])
}
