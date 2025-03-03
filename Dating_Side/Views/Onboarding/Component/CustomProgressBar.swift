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
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(width: 118, height: 3)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            Rectangle()
                .frame(width: min(CGFloat(progress) / CGFloat(total) * 118, 118), height: 3)
                .foregroundColor(.blue)
                .animation(.linear, value: progress)
        }
        .cornerRadius(10)
    }
}

