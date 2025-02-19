//
//  Font+Ext.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/02/17.
//

import SwiftUI

extension Font {
    static func pixel(_ size: CGFloat) -> Font {
        return Font.custom("Moneygraphy-Pixel", size: size)
    }
    
    static func rounded(_ size: CGFloat) -> Font {
        return Font.custom("Moneygraphy-Rounded", size: size)
    }
}
