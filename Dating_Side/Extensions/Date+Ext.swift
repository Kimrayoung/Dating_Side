//
//  Date+Ext.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/24.
//

import Foundation

extension Date {
    var hourAndMinuteString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    var todayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 언어/지역 설정
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul") // 한국 시간
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    /// [Int] → Date
        /// 입력: [year, month, day, hour, minute, second, nanosecond]
    var toIntArray: [Int] {
        let comps = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: self
        )
        return [
            comps.year ?? 0,
            comps.month ?? 0,
            comps.day ?? 0,
            comps.hour ?? 0,
            comps.minute ?? 0,
            comps.second ?? 0,
            comps.nanosecond ?? 0
        ]
    }
    
}
