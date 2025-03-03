//
//  LoginView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import SwiftUI

struct LoginView: View {
    @State private var possibleNext: Bool = false
    
    var body: some View {
        Button(action: {}, label: {
            SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .blackColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), storkBorderLineWidth: 0)
        })
    }
}

#Preview {
    LoginView()
}
