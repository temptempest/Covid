//
//  CovidMainUITests.swift
//  CovidMainUITests
//
//  Created by temptempest on 17.12.2022.
//

import XCTest

final class CovidMainUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("UITesting")
        app.launch()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func test_ScrollDown() throws {
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.scrollViews.otherElements.otherElements["Line Chart. 1 dataset. Today Recovered"].swipeUp()
    }
    
    func test_SetMyCountry_by_Cell() throws {
        let covidPageviewNavigationBar = app.navigationBars["Covid.PageView"]
        let myCountryButton = covidPageviewNavigationBar.buttons["My Country"]
        myCountryButton.tap()
        covidPageviewNavigationBar.buttons["All Countries"].tap()
        app.scrollViews.otherElements.tables.staticTexts["Afghanistan [AF]"].tap()
        let window = app.children(matching: .window).element
        window.tap()
        app.alerts["Set Your Country"].scrollViews.otherElements.buttons["OK"].tap()
        myCountryButton.tap()
    }
    
    func test_SetMyCountry_by_SearchField() {
        let covidPageviewNavigationBar = app.navigationBars["Covid.PageView"]
        let myCountryButton = covidPageviewNavigationBar.buttons["My Country"]
        myCountryButton.tap()
        covidPageviewNavigationBar.buttons["All Countries"].tap()
        let tablesQuery = app.scrollViews.otherElements.tables
        tablesQuery.searchFields["Search by Country and Code"].tap()
        app.searchFields["Search by Country and Code"].typeText("Russ")
        tablesQuery.staticTexts["Russian Federation [RU]"].tap()
        app.alerts["Set Your Country"].scrollViews.otherElements.buttons["OK"].tap()
        app.navigationBars["Covid.PageView"].buttons["My Country"].tap()
    }
}
