//
//  BottomBorderViewModifier.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/16.
//

import SwiftUI

struct BottomBorderModifier: ViewModifier {
    let color: Color
    let width: CGFloat
    let bottomPadding: CGFloat
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
                .padding(.bottom, bottomPadding)
            
            Rectangle()
                .frame(height: width)
                .foregroundColor(color)
        }
    }
}

extension View {
    func bottomBorder(color: Color = .gray, width: CGFloat = 1, bottomPadding: CGFloat = 8) -> some View {
        self.modifier(BottomBorderModifier(color: color, width: width, bottomPadding: bottomPadding))
    }
}
