//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Bogdan Fartdinov on 20.11.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    private let login = ""
    private let password = ""
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["loginButton"].tap()
        
        let webView = app.webViews["unsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 7))
        
        loginTextField.tap()
        loginTextField.typeText(login)
        app.buttons["Done"].tap()
        
        let passwordField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))
        
        passwordField.tap()
        passwordField.typeText(password)
        app.buttons["Done"].tap()
        sleep(1)
        
        webView.webViews.buttons["Login"].tap()
        
        let tableQuery = app.tables
        let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        print(app.debugDescription)
    }
    
    func testFeed() throws {
        let tableQuery = app.tables
        let cell = tableQuery.children(matching: .cell).element(boundBy: 1)
        cell.swipeUp(velocity: .slow)
        sleep(2)
        
        let cellToLike = tableQuery.children(matching: .cell).element(boundBy: 0)
        let likeButton = cellToLike.buttons["likeButton"]
        likeButton.tap()
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5))
        sleep(2)
        likeButton.tap()
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5))
        sleep(2)
        
        let topCell = tableQuery.children(matching: .cell).element(boundBy: 0)
        topCell.tap()
        
        let image = app.scrollViews.images.element(boundBy: 0)
        sleep(5)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        sleep(2)
        
        let navBackButton = app.buttons["navBackButton"]
        navBackButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(1)
        XCTAssertTrue(app.staticTexts["profileNameLabel"].exists)
        XCTAssertTrue(app.staticTexts["profileLoginNameLabel"].exists)
        XCTAssertTrue(app.buttons["exitButton"].exists)
        
        app.buttons["exitButton"].tap()
        sleep(2)
        
        XCTAssertTrue(app.buttons["loginButton"].exists)
        
    }
}
