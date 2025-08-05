//
//  ArrowNextRow.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/30.
//

import SwiftUI

struct ArrowNextRow: View {
    let label: String
    let subTitle: String?
    let completion: () -> Void
    
    var body: some View {
        Button(action: {
            completion()
        }, label: {
            HStack(content: {
                Text(label)
                    .font(.pixel(16))
                    .foregroundStyle(Color.blackColor)
                if let subTitle = subTitle {
                    Text(subTitle)
                        .font(.pixel(12))
                        .foregroundStyle(Color.gray3)
                }
                Spacer()
                Image("rightArrow")
            })
        })
        .frame(height: 48)
        .padding(.horizontal, 24)
    }
}

#Preview {
    ArrowNextRow(label: "문의하기", subTitle: nil, completion: {})
}
