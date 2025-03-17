//
//  TextWithColoredSubString.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/17.
//

import SwiftUI

struct TextWithColoredSubString: View {
    let text: String
    let highlight: String
    let gradientColors: [Color]
    
    var body: some View {
        buildText()
    }
    
    @ViewBuilder
    private func buildText() -> some View {
        let components = text.components(separatedBy: highlight)
        HStack(spacing: 0) {
            ForEach(0..<components.count, id: \.self) { index in
                Text(components[index])
                
                if index < components.count - 1 {
                    Text(highlight)
                        .foregroundColor(.clear)
                        .overlay {
                            LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing).mask(
                                Text(highlight)
                            )
                        }
                        .bold()
                }
            }
        }
    }
}

#Preview {
    TextWithColoredSubString(text: "환영해요! 러브웨이 입니다", highlight: "러브웨이", gradientColors: [.blue, .purple, .pink])
}
