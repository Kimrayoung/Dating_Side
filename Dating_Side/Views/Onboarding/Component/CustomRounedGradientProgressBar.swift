//
//  CustomRounedGradientProgressBar.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/16.
//

import SwiftUI

struct CustomRounedGradientProgressBar: View {
    let currentProgress: Int
    let total: Int
    var colors: [Color] = [Color.init(hex: "#F7E2FF"), Color.init(hex:"#D3E4FF"), Color.init(hex:"#82A8FE")]
    var barWidth: CGFloat = 174
    var barHeight: CGFloat = 8
    
    // 현재 진행 정도 계산 (0.0 ~ 1.0)
    var progress: Double {
        return Double(currentProgress) / Double(total)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            // 배경 트랙
            Rectangle()
                .foregroundColor(Color.gray.opacity(0.3))
                .frame(width: barWidth, height: barHeight)
                .cornerRadius(barHeight / 2)
            
            // 진행 그라데이션
            Rectangle()
                .frame(width: CGFloat(self.progress) * barWidth, height: barHeight)
                .foregroundStyle(
                    dynamicGradient(
                        currentProgress: currentProgress,
                        totalScreens: total,
                        width: 174
                    )
                )
                .cornerRadius(10)
                .animation(.easeInOut, value: progress)
        }
    }
    
    // 동적으로 현재 화면에 맞는 그라데이션 계산
    func dynamicGradient(currentProgress: Int, totalScreens: Int, width: CGFloat) -> LinearGradient {
        // 그라데이션 스톱(stops) 동적 생성
        var gradientStops: [Gradient.Stop] = []
        
        // 현재 화면이 전체 화면의 몇 %까지 진행되었는지 계산 -> 화면 진행률 계산
        let progressRatio = Double(currentProgress) / Double(totalScreens)
        
        // 그라데이션에서 섞이는 색상 개수
        let totalColors = colors.count
        
        // 현재까지 보여줄 색상 개수 계산 (현재 진행률에 따라)
        // ex) 4개의 화면, 3개의 색상, 1번째 화면(진행률 0.25) -> ceil(0.25) * 3 = 0.75 = 1개 색상 표시
//        let visibleColorsCount = max(1, Int(ceil(progressRatio * Double(totalColors))))
        var visibleColorsCount = 1
        if currentProgress == 1 || currentProgress == 2 { visibleColorsCount = 1 }
        else if currentProgress == 3 || currentProgress == 4 || currentProgress == 5 {visibleColorsCount = 2}
        else { visibleColorsCount = 3}
        
        // 첫 번째 색상은 항상 보임
        // 그라데이션 시작점(0,0에는 항상 첫번째 색상 배치)
        gradientStops.append(.init(color: colors[0], location: 0))
        
        if visibleColorsCount == 1 {
            // 첫 화면은 첫 번째 색상만 표시
            gradientStops.append(.init(color: colors[0], location: 1.0))
        } else {
            // 현재 진행 상태에 따라 보여줄 색상들 계산
            for i in 1..<visibleColorsCount {
                let colorIndex = min(i, colors.count - 1)
                
                // 마지막 색상이면 끝에 배치
                if i == visibleColorsCount - 1 {
                    gradientStops.append(.init(color: colors[colorIndex], location: 1.0))
                } else {
                    // 중간 색상들은 균등하게 배치
                    let position = Double(i) / Double(visibleColorsCount - 1)
                    gradientStops.append(.init(color: colors[colorIndex], location: position))
                }
            }
        }
        
        return LinearGradient(
            gradient: Gradient(stops: gradientStops),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
