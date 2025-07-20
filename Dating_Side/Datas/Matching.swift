//
//  Match.swift
//  Dating_Side
//
//  Created by 김라영 on 7/20/25.
//

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

struct UserAnswerList: Codable {
    let profileList: [UserAnswers]
}

struct UserAnswers: Codable {
    let category: String
    let contentList: [String]
}
