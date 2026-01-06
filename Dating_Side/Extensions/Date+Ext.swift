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
    
    /// 오늘을 기준으로 날짜가 얼마나 지났는지 확인
    func daysSince(_ from: Date, in timeZone: TimeZone = .current) -> Int {
        var cal = Calendar.current
        cal.timeZone = timeZone          // 예: TimeZone(identifier: "Asia/Seoul")
        let start = cal.startOfDay(for: from)
        let today = cal.startOfDay(for: Date())
        return cal.dateComponents([.day], from: start, to: today).day ?? 0
    }
    
    /// N일이 지난게 맞는지 체크
    func hasPassed(days n: Int, since from: Date, in tz: TimeZone = .current) -> Bool {
        daysSince(from, in: tz) >= n
    }
    
    
    var relativeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.unitsStyle = .short
        return formatter.localizedString(for: self, relativeTo: Date()).replacingOccurrences(of: " 전", with: "")
    }
    
    var sectionCategory: String {
        if Calendar.current.isDateInToday(self) { return "오늘" }
        if self > Calendar.current.date(byAdding: .day, value: -7, to: Date())! { return "7일" }
        return "이전"
    }
    
}

enum ISO8601 {
    // 재사용(성능)용 포매터들
    static let withFractional: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        f.timeZone = TimeZone(secondsFromGMT: 0)! // "Z" = UTC
        return f
    }()
    static let noFractional: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        f.timeZone = TimeZone(secondsFromGMT: 0)!
        return f
    }()
}

/// "2025-09-18T10:53:22.014Z" 같은 문자열 파싱
func stringToDate(_ s: String) -> Date? {
    ISO8601.withFractional.date(from: s) ?? ISO8601.noFractional.date(from: s)
}
