import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showAlert()
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}


final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    var alertPresenter: AlertPresenter?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        
        imageView.layer.cornerRadius = 20
        
        showLoadingIndicator()
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - Private functions
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        alertPresenter = AlertPresenter(modelToShowAlert:
                                            AlertModel.init(
                                                title: "Ошибка",
                                                message: message,
                                                buttonText: "Попробовать еще раз",
                                                completion: {
                                                    self.showLoadingIndicator()
                                                    self.presenter.questionFactory?.loadData()
                                                    self.presenter.questionFactory?.requestNextQuestion()
                                                }))
        
        alertPresenter?.alertViewController = self
        alertPresenter?.showAlert()
    }
    
    func showAlert(){
        
        let text = presenter.makeResultsMessage()
        
        alertPresenter = AlertPresenter(modelToShowAlert:
                                            AlertModel.init(
                                                title: "Этот раунд окончен!",
                                                message: text,
                                                buttonText: "Сыграть ещё раз",
                                                completion: {
                                                    self.presenter.restartGame()
                                                }))
        
        alertPresenter?.alertViewController = self
        alertPresenter?.showAlert()
    }
    
    func show(quiz step: QuizStepViewModel) {
        
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
}
