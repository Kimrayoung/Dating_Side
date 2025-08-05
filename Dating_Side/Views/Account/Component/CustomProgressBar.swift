//
//  CustomProgressBar.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import SwiftUI

struct CustomProgressBar: View {
    var progress: Int
    var total: Int
    var hexColors: [String] = ["#F7E2FF", "#D3E4FF", "#82A8FE"]
    var foregroundHex: String = "#EBEFF6"  // 프로그레스 바 색상 (기본: 흰색)
    var barWidth: CGFloat = 174
    var barHeight: CGFloat = 8
    
    private var progressPercentage: CGFloat {
        CGFloat(progress) / CGFloat(total)
    }
    
    private var colors: [Color] {
        hexColors.map { Color(hex: $0) }
    }
    
    private var foregroundColor: Color {
        Color(hex: foregroundHex)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            // 그라디언트 배경 바
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: colors),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: barWidth, height: barHeight)
            
            // 점차 줄어드는 전경 바 (프로그레스 역할)
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    // 비어있는 공간 (프로그레스 만큼)
                    Rectangle()
                        .frame(width: geometry.size.width * progressPercentage)
                        .opacity(0)
                    
                    // 아직 진행되지 않은 부분 (가림막 역할)
                    Rectangle()
                        .frame(width: geometry.size.width * (1 - progressPercentage))
                        .foregroundColor(foregroundColor)
                }
            }
            .frame(width: barWidth, height: barHeight)
            .animation(.linear, value: progress)
        }
        .cornerRadius(barHeight / 2)
    }
}

