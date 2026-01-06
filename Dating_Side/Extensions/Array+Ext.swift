//
//  Array+Ext.swift
//  Dating_Side
//
//  Created by 안세훈 on 12/18/25.
//

import Foundation

extension Array where Element == Int {
    var toDate: Date? {
        guard self.count >= 6 else { return nil }
        
        var components = DateComponents()
        components.year = self[0]
        components.month = self[1]
        components.day = self[2]
        components.hour = self[3]
        components.minute = self[4]
        components.second = self[5]
        if self.count > 6 { components.nanosecond = self[6] }
        
        return Calendar.current.date(from: components)
    }
}
