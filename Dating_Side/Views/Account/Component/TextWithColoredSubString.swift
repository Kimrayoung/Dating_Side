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
        // 1. split on your highlight
        let parts = text.components(separatedBy: highlight)
        
        // 2. start with the first segment
        var composed = Text(parts[0])
        
        // 3. append highlight + next piece, for each occurrence
        for idx in 0..<parts.count - 1 {
            composed = composed +
            Text(highlight)
            // apply gradient *directly* as the foreground style,
            // no need for clear‑color + overlay
                .foregroundStyle(
                    .linearGradient(
                        colors: gradientColors,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .bold()
            composed = composed + Text(parts[idx+1])
        }
        
        // 4. let SwiftUI wrap it naturally
        return composed
            .multilineTextAlignment(.center)
    }}

#Preview {
    TextWithColoredSubString(text: "이제 러브웨이에서\n어떤 사랑을 하고 싶나요?", highlight: "러브웨이", gradientColors: [.blue, .purple, .pink])
}
