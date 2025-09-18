//
//  MatchingNetworkManager.swift
//  Dating_Side
//
//  Created by 김라영 on 7/20/25.
//

import Foundation
import Logging

/// 질문과 관련된 network(오늘의 질문, 질문 대답들)
struct QuestionNetworkManager {
    private let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchTodayQuestions() async throws -> Result<TodayQuestionList, Error> {
        return await networkManager.callWithAsync(endpoint: QuestionAPIManager.getTodayQuestions, httpCodes: .success)
    }
    
    /// 두번째 매칭을 위해서 내가 보낼 질문
    func postMyQuestionAnswer(question: MyQuestion) async throws -> Result<VoidResponse, Error> {
        return await networkManager.callWithAsync(endpoint: QuestionAPIManager.postMyQuestions(question: question), httpCodes: .success)
    }
    
    /// 오늘의 질문에 대한 답변
    func postTodayQuestionAnswer(answer: TodayQuestionAnswer) async throws -> Result<TodayQuestionResponse, Error> {
        return await networkManager.callWithAsync(endpoint: QuestionAPIManager.postTodayQuestionAnswer(answer: answer), httpCodes: .success)
    }
    
    /// 추가 질문 보냈는지 확인
    func fetchDidSendTodayQuestion() async throws -> Result<BoolResponse, Error> {
        return await networkManager.callWithAsync(endpoint: QuestionAPIManager.didSendTodayQuestion, httpCodes: .success)
    }
    
}

enum QuestionAPIManager {
    /// 오늘의 질문 조회
    case getTodayQuestions
    /// 내가 보낼 질문
    case postMyQuestions(question: MyQuestion)
    /// 오늘의 질문 답변한거 전송
    case postTodayQuestionAnswer(answer: TodayQuestionAnswer)
    /// 오늘의 질문 보냈는지 확인
    case didSendTodayQuestion
    /// 유저의 카테고리별 답변을 조회(ex. 연애관에 관련된 대답들)
    
}

extension QuestionAPIManager: APIManager {
    var path: String {
        switch self {
        case .postMyQuestions, .didSendTodayQuestion:
            return "questions"
        case .getTodayQuestions:
            return "questions/today"
        case .postTodayQuestionAnswer:
            return "profile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getTodayQuestions, .didSendTodayQuestion: .get
        case .postMyQuestions, .postTodayQuestionAnswer: .post
        }
    }
    
    var headers: [String : String]? {
        guard let accessToken = KeychainManager.shared.getAccessToken() else {
            Log.errorPublic("accessToken이 없음")
            AppState.shared.offAuthenticated()
            AlertManager.shared.loginExpiredAlert()
            return nil
        }
        Log.debugPublic("accessToken", accessToken)
        return [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer " + accessToken
        ]
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
