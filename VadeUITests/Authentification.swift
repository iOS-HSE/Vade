//
//  Authentification.swift
//  VadeUITests
//
//  Created by Egor on 21.11.2020.
//

import XCTest

class Authentification: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func skipOnboarding(app: XCUIApplication) {
        for x in 0..<4 {
            let view = app.otherElements["OnboardView_\(x)"]
            view.buttons.element.tap()
        }
    }
    
    func testTryToSignUpWithIncorrectPassword() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        if (app.scrollViews.otherElements.staticTexts["Welcome"].isHittable) {
            skipOnboarding(app: app)
        }

        app/*@START_MENU_TOKEN@*/.staticTexts["Sign Up"]/*[[".buttons[\"Sign Up\"].staticTexts[\"Sign Up\"]",".staticTexts[\"Sign Up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let doneButton = app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards",".buttons[\"done\"]",".buttons[\"Done\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        
        let firstNameTextField = app.textFields["First Name"]
        firstNameTextField.tap()
        firstNameTextField.typeText("name")
        doneButton.tap()
        
        let lastNameTextField = app.textFields["Last Name"]
        lastNameTextField.tap()
        lastNameTextField.typeText("last")
        doneButton.tap()
        
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("e@e.com")
        doneButton.tap()
        
        let passwordTextField = app.textFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("incorrect")
        doneButton.tap()
        
        app.buttons["Sign Up"].staticTexts["Sign Up"].tap()
        let alertMessage = "Please make sure your password at least 8 chars, contains a number, upper and lowercase symbols"
        XCTAssert(app.alerts.element.staticTexts[alertMessage].exists)
    }
    
    func testTryToSignUpWithEmptyFields() throws {
        let app = XCUIApplication()
        app.launch()
        
        if (app.scrollViews.otherElements.staticTexts["Welcome"].isHittable) {
            skipOnboarding(app: app)
        }
        app/*@START_MENU_TOKEN@*/.staticTexts["Sign Up"]/*[[".buttons[\"Sign Up\"].staticTexts[\"Sign Up\"]",".staticTexts[\"Sign Up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.buttons["Sign Up"].staticTexts["Sign Up"].tap()
        let alertMessage = "Please, fill in all fields!"
        XCTAssert(app.alerts.element.staticTexts[alertMessage].exists)
    }
}
