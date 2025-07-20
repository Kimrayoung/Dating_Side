//
//  MatchingNetworkManager.swift
//  Dating_Side
//
//  Created by 김라영 on 7/20/25.
//

import Foundation

class MatchingNetworkManager {
    private let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchTodayQuestions() async throws -> Result<TodayQuestionList, Error> {
        return await networkManager.callWithAsync(endpoint: MatchingAPIManager.getTodayQuestions, httpCodes: .success)
    }
    
    func postMyQuestionAnswer(question: MyQuestion) async throws -> Result<VoidResponse, Error> {
        return await networkManager.callWithAsync(endpoint: MatchingAPIManager.postMyQuestions(question: question), httpCodes: .success)
    }
    
    func postTodayQuestionAnswer(answer: TodayQuestionAnswer) async throws -> Result<VoidResponse, Error> {
        return await networkManager.callWithAsync(endpoint: MatchingAPIManager.postTodayQuestionAnswer(answer: answer), httpCodes: .success)
    }
    
    func getUserAnswerList() async throws -> Result<UserAnswerList, Error> {
        return await networkManager.callWithAsync(endpoint: MatchingAPIManager.getUserAnswerList, httpCodes: .success)
    }
    
}

enum MatchingAPIManager {
    /// 오늘의 질문 조회
    case getTodayQuestions
    /// 내가 보낼 질문
    case postMyQuestions(question: MyQuestion)
    /// 오늘의 질문 답변한거 전송
    case postTodayQuestionAnswer(answer: TodayQuestionAnswer)
    /// 유저의 카테고리별 답변을 조회(ex. 연애관에 관련된 대답들)
    case getUserAnswerList
}

extension MatchingAPIManager: APIManager {
    var path: String {
        switch self {
        case .getTodayQuestions, .postMyQuestions:
            return "questions"
        case .postTodayQuestionAnswer, .getUserAnswerList:
            return "profile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getTodayQuestions, .getUserAnswerList: .get
        case .postMyQuestions, .postTodayQuestionAnswer: .post
        }
    }
    
    var headers: [String : String]? {
        if let accessToken = KeychainManager.shared.getToken(service: "com.loveway.auth", account: "accessToken") {
            return [
                "Content-Type" : "application/json",
                "SMS_Authorization" : "Bearer " + accessToken
            ]
        } else { return nil }
    }
    
    func body() throws -> Data? {
        switch self {
        case .postMyQuestions(let question):
            let jsonEncoder = JSONEncoder()
            return try jsonEncoder.encode(question)
        case .postTodayQuestionAnswer(let answer):
            let jsonEncoder = JSONEncoder()
            return try jsonEncoder.encode(answer)
        default: return nil
        }
    }
    
    
}
