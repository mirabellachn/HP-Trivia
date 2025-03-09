//
//  Game.swift
//  HP Trivia
//
//  Created by mirabella  on 09/03/25.
//

import Foundation


@MainActor
class Game: ObservableObject {
    private var allQuestions: [Question] = []
    private var answeredQuestion: [Int] = []
    
    var filteredQuestions: [Question] = []
    var currentQuestion = Constants.previewQuestion
    var answers: [String] = []
    
    var correctAnswer: String {
        currentQuestion.answers.first(where: { $0.value == true })!.key
    }
    
    init() {
        decodeQuestions()
    }
    
    func filterQuestions(to books: [Int]) {
        filteredQuestions = allQuestions.filter { books.contains($0.book) }
    }
    
    func newQuestion() {
        if filteredQuestions.isEmpty {
            return
        }
        
        if answeredQuestion.count == filteredQuestions.count {
            answeredQuestion = []
        }
        
        var potentialQuestion = filteredQuestions.randomElement()!
        while answeredQuestion.contains(potentialQuestion.id) {
            potentialQuestion = filteredQuestions.randomElement()!
        }
        currentQuestion = potentialQuestion
        
        answers = []
        
        for answer in currentQuestion.answers.keys {
            answers.append(answer)
        }
        
        answers.shuffle()
    }
    
    func correct() {
        answeredQuestion.append(currentQuestion.id)
        
        // Todo: Update Score
    }
    
    private func decodeQuestions() {
        if let url = Bundle.main.url(forResource: "trivia", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                allQuestions = try decoder.decode([Question].self, from: data)
                filteredQuestions = allQuestions
                print(allQuestions)
            } catch {
                print("Error decoding JSON data: \(error)")
            }
        }
    }
}
