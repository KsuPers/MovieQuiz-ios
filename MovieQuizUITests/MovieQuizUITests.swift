import XCTest

class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    
    func testYesButton() {
        let Poster = XCUIApplication().images["Poster"]
        let screenshotBefore = Poster.screenshot()
        app.buttons["Да"].tap()
        let screenshotAfter = Poster.screenshot()
        let indexLabel = app.staticTexts["Index"]

        sleep(2)
        
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertNotEqual(screenshotBefore.pngRepresentation, screenshotAfter.pngRepresentation)
    }
    
    func testNoButton () {
        
        let Poster = XCUIApplication().images["Poster"]
        let screenshotBefore = Poster.screenshot()
        app.buttons["Нет"].tap()
        let screenshotAfter = Poster.screenshot()
        let indexLabel = app.staticTexts["Index"]

        sleep(2)
        
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertNotEqual(screenshotBefore.pngRepresentation, screenshotAfter.pngRepresentation)
    }
    
    func testGameFinish() {
        while app.staticTexts["Index"].label != "10/10" {
            app.buttons["No"].tap()
        }
        
        sleep(2)
        
        let alert = app.alerts.firstMatch
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
    func testAlertDismiss(){
        while app.staticTexts["Index"].label != "10/10" {
            app.buttons["No"].tap()
        }
        
        sleep(2)
        
        let alert = app.alerts.firstMatch
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
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
