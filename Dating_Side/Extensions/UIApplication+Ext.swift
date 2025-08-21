//
//  UIApplication+Ext.swift
//  Dating_Side
//
//  Created by 김라영 on 8/20/25.
//

import UIKit

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil, from: nil, for: nil)
    }
}
