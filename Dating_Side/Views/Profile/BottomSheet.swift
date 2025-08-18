//
//  BottomSheet.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/15.
//

import SwiftUI

struct ProfileCheckBottomSheet: View {
    @Binding var showModal: Bool
    @State private var dragOffset: CGFloat = 0.0
    @Binding var currentHeightRatio: CGFloat // 시작 높이: 화면 높이의 20%

    let minHeightRatio: CGFloat = 0.45
    let maxHeightRatio: CGFloat = 0.6

    var body: some View {
        GeometryReader { geometry in
            let totalHeight = geometry.size.height
            let height = totalHeight * currentHeightRatio + dragOffset

            VStack {
                Image("upArrow")
                    .resizable()
                    .frame(width: 15, height: 21)
                    .padding(.top, 15)
                Text("위로 올려서\n매칭된 상대 확인하기")
                    .multilineTextAlignment(.center)
                    .font(.pixel(20))
                    .foregroundStyle(Color.mainColor)

                Spacer()
            }
            .frame(width: geometry.size.width,
                   height: max(totalHeight * minHeightRatio,
                               min(height, totalHeight * maxHeightRatio))
            )
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = -value.translation.height
                    }
                    .onEnded { value in
                        let newRatio = currentHeightRatio + (-value.translation.height / totalHeight)
                        let clampedRatio = max(minHeightRatio, min(maxHeightRatio, newRatio))
                        currentHeightRatio = max(minHeightRatio, min(maxHeightRatio, newRatio))
                        dragOffset = 0
                        
                        if clampedRatio >= maxHeightRatio {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                showModal = true
                            }
                        }
                    }
            )
            .animation(.spring(), value: dragOffset)
            .animation(.spring(), value: currentHeightRatio)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
