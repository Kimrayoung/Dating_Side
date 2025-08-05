//
//  WelcomeText.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/17.
//

import SwiftUI

struct WelcomeText: View {
    var body: some View {
        VStack(spacing: 0, content: {
            TextWithColoredSubString(
                text: "환영해요! 러브웨이 입니다",
                highlight: "러브웨이",
                gradientColors: [Color(hex: "#FBB1F3"), Color(hex: "#82A8FE"), Color(hex: "#D3E4FF")]
            )
            Text("가입을 위해 전화번호를 입력해주세요")
            
        })
        
    }
}

#Preview {
    WelcomeText()
}
