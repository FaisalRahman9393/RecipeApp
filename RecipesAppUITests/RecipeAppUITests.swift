//
//  RecipeAppUITests.swift
//  RecipesAppUITests
//
//  Created by Faisal Rahman on 01/05/2025.
//

import XCTest

final class RecipesAppUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testTappingRecipeShowsDetail() throws {
        let firstCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10), "First recipe cell should be present")
        
        firstCell.tap()

        let instructionsLabel = app.staticTexts["Instructions"]
        XCTAssertTrue(instructionsLabel.waitForExistence(timeout: 10), "Detail view should display 'Instructions' heading")
    }
}
