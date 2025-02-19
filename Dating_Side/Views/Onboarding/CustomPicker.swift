////
////  CustomPicker.swift
////  Dating_Side
////
////  Created by 김라영 on 2025/02/17.
////
//
import SwiftUI

struct CustomPickerItem: Identifiable {
    let id: Int
    let value: String
}


struct CustomPicker: View {
    @Binding var selectedIndex: Int?
    var items: [CustomPickerItem]
    var itemHeight: CGFloat = 40.0
    var menuHeightMultiplier: CGFloat = 20
    
    var body: some View {
        let itemsCountAbove = Double(Int((menuHeightMultiplier - 1)/2))
        let degressMultiplier: Double = -40.0 / itemsCountAbove
        let scaleMultiplier: CGFloat = 0.1 / itemsCountAbove
        
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVStack(spacing: 0){
                    ForEach(0..<items.count, id: \.self) { index in
                        let item = items[index]
                        let indexDiff = Double(index-(selectedIndex ?? 0))
                        HStack {
                            Text(item.value)
                                .foregroundStyle(index == selectedIndex ? .black : .gray)
                                .font(.pixel(14))
                                .padding()
                                .frame(width: 100)
                                .id(index)
                        }
                        .frame(height: index == selectedIndex ? itemHeight : 20)
                        .rotation3DEffect(Angle(degrees: indexDiff * degressMultiplier),
                                       axis: (x: 1.0, y: 0.0, z: 0.0),
                                       perspective: 0.6)
                        .scaleEffect(x: 1 - CGFloat(abs(indexDiff)*scaleMultiplier))
                    }
                }
                .scrollTargetLayout()
                .padding(.vertical, itemHeight * itemsCountAbove)
            }
            .scrollPosition(id: $selectedIndex, anchor: .center)
            .frame(height: itemHeight * (itemsCountAbove * 2 + 1))
            .overlay(alignment: .center) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray2.opacity(0.2))
                    .frame(height: itemHeight)
                    .allowsHitTesting(false)
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .onAppear {
                if selectedIndex == nil {
                    selectedIndex = 0
                }
                proxy.scrollTo(selectedIndex, anchor: .center)
            }
        }
    }
}
