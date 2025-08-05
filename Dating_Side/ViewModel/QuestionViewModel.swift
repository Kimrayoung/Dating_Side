//
//  MatchingViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 7/20/25.
//

import Combine
import Foundation

class QuestionViewModel: ObservableObject {
    @Published var category: String = ""
    @Published var questionList: [Question] = []
    @Published var answers: [Int: String] = [:] // [question.id: 답변]
    @Published var currentIndex: Int = 0        // 현재 질문 인덱스
    let loadingManager = LoadingManager.shared
    var questionNetworkmanager = QuestionNetworkManager()
    
    var currentQuestion: Question {
        questionList[currentIndex]
    }
    
    var isLastQuestion: Bool {
        currentIndex == questionList.count - 1
    }
    
    func next() {
        guard !isLastQuestion else { return }
        currentIndex += 1
    }
}


extension QuestionViewModel {
    @MainActor
    func fetchTodayQuestions() async {
        loadingManager.isLoading = true
        defer {
            self.loadingManager.isLoading = false
        }
        do {
            let result = try await questionNetworkmanager.fetchTodayQuestions()
            switch result {
            case .success(let questions):
                self.category = questions.category
                self.questionList = questions.questions.enumerated().map { idx, text in
                    Question(id: idx + 1, text: text)
                }
            case .failure(let error):
                Log.errorPublic("fetchQuestions error: \(error)")
            }
        } catch {
            Log.errorPublic("fetchQuestions error: \(error)")
        }
    }
    
    @MainActor
    func postTodayQuetionAnswers(completion: @escaping (Bool) -> Void) async {
        let answerList = self.answers.map { $0.value }
        let todayQuestionAnswers = TodayQuestionAnswer(answerList: answerList)
        loadingManager.isLoading = true
        defer {
            self.loadingManager.isLoading = false
        }
        Log.debugPublic("today question checking answer: \(answerList)")
        do {
            let result = try await questionNetworkmanager.postTodayQuestionAnswer(answer: todayQuestionAnswers)
            switch result {
            case .success:
                Log.debugPublic("postTodayQuetionAnswres success")
                completion(true)
            case .failure(let error):
                Log.errorPublic("postTodayQuetionAnswres error: \(error)")
                completion(false)
            }
        } catch {
            Log.errorPublic("postTodayQuetionAnswres error: \(error)")
            completion(false)
        }
    }
    
    func postMyQuestion(question: MyQuestion) async {
        loadingManager.isLoading = true
        defer {
            self.loadingManager.isLoading = false
        }
        do {
            let result = try await questionNetworkmanager.postMyQuestionAnswer(question: question)
            switch result {
            case .success:
                Log.debugPublic("postMyQuetionAnswres success")
            case .failure(let error):
                Log.errorPublic("postMyQuetionAnswres error: \(error)")
            }
        } catch {
            Log.errorPublic("postMyQuetionAnswres error: \(error)")
        }
    }
}
