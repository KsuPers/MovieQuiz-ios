import Foundation
import UIKit

final class MovieQuizPresenter{
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    func isLastQuestion () -> Bool{
        if (currentQuestionIndex == questionsAmount - 1) {
            return true
        }
        return false
    }
    
    func resetQuestionIndex () {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion () {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage (data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
}

