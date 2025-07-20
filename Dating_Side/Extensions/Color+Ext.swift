//
//  Color+Ext.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/17.
//

import SwiftUI
import UIKit

extension Color {
    // HEX 문자열로 색상 생성 (ex: "#FF0000" or "FF0000")
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// #8494F6
    static let mainColor = Color(hex: "#8494F6")
    /// #EAEFFD
    static let subColor = Color(hex: "#EAEFFD")
    /// #DAE4FF
    static let subColor1 = Color(hex: "#DAE4FF")
    /// #CBD8FB
    static let subColor2 = Color(hex: "#CBD8FB")
    /// #121212
    static let blackColor = Color(hex: "#121212")
    /// #FDFDFF
    static let whiteColor = Color(hex: "#FDFDFF")
    /// #656B79
    static let gray3 = Color(hex: "#656B79")
    /// #828282
    static let gray2 = Color(hex: "#888888")
    /// #C6CEE0
    static let gray01 = Color(hex: "#C6CEE0")
    /// #DCDCDC
    static let gray0 = Color(hex: "#E8E8E8")
    
}

extension UIColor {
    convenience init(hex: String) {
        // 1) 불필요한 문자 제거
        let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hexString).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hexString.count {
        case 3: // RGB (12-bit: RGB each 1 hex digit)
            (a, r, g, b) = (
                255,
                (int >> 8) * 17,
                (int >> 4 & 0xF) * 17,
                (int & 0xF) * 17
            )
        case 6: // RRGGBB (24-bit)
            (a, r, g, b) = (
                255,
                int >> 16,
                int >> 8 & 0xFF,
                int & 0xFF
            )
        case 8: // AARRGGBB (32-bit)
            (a, r, g, b) = (
                int >> 24,
                int >> 16 & 0xFF,
                int >> 8 & 0xFF,
                int & 0xFF
            )
        default:
            // 잘못된 포맷: 검은색으로 폴백
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            red:   CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue:  CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
    
}
