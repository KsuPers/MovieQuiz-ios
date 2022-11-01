import XCTest

class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    func testYesButton () {
        
        let firstPoster = app.images["Poster"]
        app.buttons["Да"].tap()
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster)
    }
    
    func testNoButton () {
        
        let firstPoster = app.images["Poster"]
        app.buttons["Нет"].tap()
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster)
    }
    
    func testGameFinish() {
        while app.staticTexts["Index"].label != "10/10" {
            app.buttons["No"].tap()
        }
        
        sleep(3)
        
        let alert = app.alerts.firstMatch
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
    func testAlertDismiss(){
        while app.staticTexts["Index"].label != "10/10" {
            app.buttons["No"].tap()
        }
        
        sleep(3)
        
        let alert = app.alerts.firstMatch
        alert.buttons.firstMatch.tap()
        
        sleep(3)
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(app.staticTexts["Index"].label == "1/10")
    }
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        app.terminate()
        app = nil
    }
}
