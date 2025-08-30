//
//  CheckRow.swift
//  Dating_Side
//
//  Created by 김라영 on 8/30/25.
//

import SwiftUI


struct CheckRow: View {
    @Binding var isOn: Bool
    let title: String
    
    var body: some View {
        HStack(spacing: 12) {
            CheckIcon(isOn: isOn)
            Text(title)
                .font(.pixel(16))
                .foregroundStyle(Color.blackColor)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 8)
    }
}
