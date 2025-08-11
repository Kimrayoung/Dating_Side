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

}
