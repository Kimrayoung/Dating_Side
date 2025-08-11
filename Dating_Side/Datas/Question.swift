//
//  Match.swift
//  Dating_Side
//
//  Created by 김라영 on 7/20/25.
//

struct Question: Hashable, Identifiable {
    var id: Int
    var text: String
}

struct MyQuestion: Codable {
    let category: String
    let question: String
}

struct TodayQuestionList: Codable {
    let category: String
    let questions: [String]
}

struct TodayQuestionAnswer: Codable {
    let answerList: [String]
}

struct TodayQuestionResponse: Codable {
    let result: String
}

struct UserAnswerList: Codable {
    let profileList: [UserAnswers]
}

struct UserAnswers: Codable, Hashable {
    let category: String
    let profileList: [Answer]
}

struct Answer: Codable, Hashable {
    let content: String
    let date: String
}

enum UserAnswerCategory: String {
    case LOVE = "연애"
    case MARRIAGE = "결혼"
    case WORK = "직장"
    case LIFE = "생활"
    case ETC = "기타"
    
    var korean: String {
        switch self {
        case .LOVE:
            return "연애"
        case .MARRIAGE:
            return "결혼"
        case .WORK:
            return "직장"
        case .LIFE:
            return "생활"
        case .ETC:
            return "기타"
        }
    }
    
    var imageString: String {
        switch self {
        case .LOVE:
            return "loveView"
        case .MARRIAGE:
            return "marryView"
        case .WORK:
            return "workView"
        case .LIFE:
            return "lifeView"
        case .ETC:
            return ""
        }
    }
    
    var index: Int {
        switch self {
        case .LOVE:
            return 0
        case .MARRIAGE:
            return 1
        case .WORK:
            return 2
        case .LIFE:
            return 3
        case .ETC:
            return 4
        }
    }
}

extension UserAnswerCategory {
    init?(index: Int) {
        switch index {
        case 0: self = .LOVE
        case 1: self = .MARRIAGE
        case 2: self = .WORK
        case 3: self = .LIFE
        case 4: self = .ETC
        default: return nil
        }
    }
}

