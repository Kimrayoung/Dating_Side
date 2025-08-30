//
//  CheckIcon.swift
//  Dating_Side
//
//  Created by 김라영 on 8/30/25.
//

import SwiftUI

struct CheckIcon: View {
    var isOn: Bool
    var body: some View {
        Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
            .font(.system(size: 22, weight: .semibold))
            .foregroundStyle(isOn ? Color.mainColor : Color.gray3)
            .frame(width: 28, height: 28)
    }
}
