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
    /// 이미 오늘의 질문 리스트에 답변을 전부 했을 경우
    @Published var questionComplete: Bool = false
    @Published var todayQuestionAnswer: String = ""
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
    
    var isFirstQuestion: Bool {
        currentIndex == 0
    }
    
    func nextQuestion() {
        guard !isLastQuestion else { return }
        currentIndex += 1
    }
    
    func previousQuestion() {
        guard !isFirstQuestion else { return }
        currentIndex -= 1
    }
}


extension QuestionViewModel {
    @MainActor
    /// 오늘의 질문 리스트
    func fetchTodayQuestions() async {
        loadingManager.isLoading = true
        defer {
            self.loadingManager.isLoading = false
        }
        do {
            let result = try await questionNetworkmanager.fetchTodayQuestions()
            switch result {
            case .success(let questions):
                self.category = questions.categoryType.korean
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
    /// 오늘의 질문 리스트에 대한 답변
    func postTodayQuetionAnswers() async -> String {
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
            case .success(let answer):
                Log.debugPublic("postTodayQuetionAnswres success")
                return answer.result
            case .failure(let error):
                Log.errorPublic("postTodayQuetionAnswres error: \(error)")
            }
        } catch {
            Log.errorPublic("postTodayQuetionAnswres error: \(error)")
        }
        return ""
    }
    
    /// 추가 매칭을 위한 질문 보내기
    @MainActor
    func postMyQuestion(question: MyQuestion) async -> Bool {
        loadingManager.isLoading = true
        defer {
            self.loadingManager.isLoading = false
        }
        do {
            let result = try await questionNetworkmanager.postMyQuestionAnswer(question: question)
            switch result {
            case .success:
                Log.debugPublic("postMyQuetionAnswres success")
                return true
            case .failure(let error):
                Log.errorPublic("postMyQuetionAnswres error: \(error)")
            }
        } catch {
            Log.errorPublic("postMyQuetionAnswres error: \(error)")
        }
        return false
    }
    
    @MainActor
    /// 추가 매칭을 위한 오늘 질문 보내기를 했는지
    func alreadySendTodayQuestion() async -> Bool {
        loadingManager.isLoading = true
        defer {
            self.loadingManager.isLoading = false
        }
        
        do {
            let result = try await questionNetworkmanager.fetchDidSendTodayQuestion()
            switch result {
            case .success(let result):
                return result.result
            case .failure(let error):
                Log.errorPublic("alreadySendTodayQuestion error: \(error)")
                return false
            }
        } catch {
            Log.errorPublic("error", error.localizedDescription)
        }
        return false
    }
    
    @MainActor
    /// 오늘의 질문들에 답변했는지(기본으로 오는 오늘의 질문에)
    func checkingTodayQuestionAnswer() async -> Bool {
        Log.debugPublic("오늘 질문들에 답변했는지 : ")
        let profileNetworkManager = ProfileNetworkManager()
        
        loadingManager.isLoading = true
        defer {
            self.loadingManager.isLoading = false
        }
        
        do {
            let result = try await profileNetworkManager.getUserAnswerList()
            
            switch result {
            case .success(let userAnswerList):
                
                let today = Date().todayString
                var answerList: [UserAnswerCategory : [Answer]] = [:]
                userAnswerList.profileList.forEach { profile in
                    answerList[profile.categoryType] = profile.profileList
                }
                Log.debugPublic("오늘 질문들에 답변했는지 : ", userAnswerList)
                for category in answerList {
                    for item in category.value {
                        if item.dateString == today {
                            self.category = category.key.korean
                            todayQuestionAnswer = item.content
                            return true
                        }
                    }
                }
                
                return false
            case .failure(let error):
                Log.errorPublic("오늘 질문들에 답변했는지 ", error.localizedDescription)
                return false
            }
        } catch {
            Log.errorPublic("유저 가치관 정보 가져오기 오류", error.localizedDescription)
        }
        
        return false
    }
}
