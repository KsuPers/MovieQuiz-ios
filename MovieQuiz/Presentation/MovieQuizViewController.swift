import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private let presenter = MovieQuizPresenter()
    
    weak var alertViewController: UIViewController?
    //private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    //private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    //private var currentQuestion: QuizQuestion?
    var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        presenter.viewController = self
        
        imageView.layer.cornerRadius = 20
        
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        questionFactory?.loadData()
        showLoadingIndicator()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - Private functions
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        alertPresenter = AlertPresenter(modelToShowAlert:
                                            AlertModel.init(
                                                title: "Ошибка",
                                                message: message,
                                                buttonText: "Попробовать еще раз",
                                                completion: {
                                                    self.showLoadingIndicator()
                                                    self.questionFactory?.loadData()
                                                    self.questionFactory?.requestNextQuestion()
                                                }))
        
        alertPresenter?.alertViewController = self
        showAlert()
    }
    
    func showAlert(){
        guard let statisticService = statisticService else {
            return
        }
        
        statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
        
        
        let text = """
Ваш результат: \(correctAnswers) из \(presenter.questionsAmount)
Количество сыгранных квизов: \(statisticService.gamesCount)
Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy as CVarArg))%
"""
        
        alertPresenter = AlertPresenter(modelToShowAlert:
                                            AlertModel.init(
                                                title: "Этот раунд окончен!",
                                                message: text,
                                                buttonText: "Сыграть ещё раз",
                                                completion: {
                                                    self.presenter.resetQuestionIndex()
                                                    self.correctAnswers = 0
                                                    self.questionFactory?.requestNextQuestion()
                                                }))
        
        
        alertPresenter?.alertViewController = self
        guard let alertPresenter = alertPresenter else { return }
        alertPresenter.showAlert()
    }
    
    func show(quiz step: QuizStepViewModel) {
        
        guard let currentQuestion = presenter.currentQuestion else { return }
        imageView.layer.borderColor = UIColor.clear.cgColor
        counterLabel.text = presenter.convert(model: currentQuestion).questionNumber
        textLabel.text = presenter.convert(model: currentQuestion).question
        imageView.image = presenter.convert(model: currentQuestion).image
    }
    /*
     
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showNextQuestionOrResults() {
        if  presenter.isLastQuestion()
        {
            
            guard let statisticService = statisticService else {
                return
            }
            
            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
            
            
            let text = """
Ваш результат: \(correctAnswers) из \(presenter.questionsAmount)
Количество сыгранных квизов: \(statisticService.gamesCount)
Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy as CVarArg))%
"""
            
            alertPresenter = AlertPresenter(modelToShowAlert:
                                                AlertModel.init(
                                                    title: "Этот раунд окончен!",
                                                    message: text,
                                                    buttonText: "Сыграть ещё раз",
                                                    completion: {
                                                        self.presenter.resetQuestionIndex()
                                                        self.correctAnswers = 0
                                                        self.questionFactory?.requestNextQuestion()
                                                    }))
            
            alertPresenter?.viewController = self
            showAlert()
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
     */
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter (deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.correctAnswers = self.correctAnswers
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
            
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
}
