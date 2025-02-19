//
//  SelectCell.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/10.
//

import SwiftUI

struct SelectButtonLabel: View {
    @Binding var isSelected: Bool
    var height: CGFloat
    var text: String
    var backgroundColor: Color = .red
    var selectedBackgroundColor: Color = .blackColor
    var textColor: Color = .black
    var selectedTextColor: Color = .white
    var cornerRounded: CGFloat = 8
    var font: Font = .rounded(14)
    var storkBorderLineWidth: CGFloat = 1
    var selectedStrokeBorderLineWidth: CGFloat = 2
    
    var body: some View {
        Text(text)
            .font(font)
            .foregroundStyle(isSelected ? selectedTextColor : textColor)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(
                RoundedRectangle(cornerRadius: cornerRounded)
                    .fill(isSelected ? selectedBackgroundColor : backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRounded)
                    .strokeBorder(Color.black, lineWidth: isSelected ? selectedStrokeBorderLineWidth : storkBorderLineWidth)
            )
    }
}

#Preview {
    SelectButtonLabel(isSelected: .constant(false), height: 30, text: "hi", backgroundColor: .red)
}
