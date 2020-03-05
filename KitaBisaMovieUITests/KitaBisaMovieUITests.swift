//
//  KitaBisaMovieUITests.swift
//  KitaBisaMovieUITests
//
//  Created by Rasyadh Abdul Aziz on 05/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import XCTest

class KitaBisaMovieUITests: XCTestCase {
    
    var app: XCUIApplication!
    private var languageBundle: Bundle!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app = XCUIApplication()
        languageBundle = setLocalizableTest()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialHomeView() {
        app.launch()
        
        XCTAssertTrue(app.isDisplayingHome)
    }
    
    func testHomeElements() {
        app.launch()
        
        let window = app.windows.element(boundBy: 0)
        let favouriteItem = app.navigationBars[get(bundle: languageBundle, "app.name")].buttons["favouriteItem"]
        let tableView = app.tables
        let categoryButton = app.buttons[get(bundle: languageBundle, "home.button.category")]
        
        XCTAssertTrue(favouriteItem.exists)
        XCTAssert(window.frame.contains(tableView.accessibilityFrame))
        XCTAssertTrue(categoryButton.exists)
    }
    
    func testInitialFavouriteMovieView() {
        app.launch()
        app.navigationBars[get(bundle: languageBundle, "app.name")].buttons["favouriteItem"].tap()
        
        XCTAssertTrue(app.isDisplayingFavouriteMovie)
    }
    
    func testFavouriteMovieElements() {
        app.launch()
        app.navigationBars[get(bundle: languageBundle, "app.name")].buttons["favouriteItem"].tap()
        
        let window = app.windows.element(boundBy: 0)
        let title = app.navigationBars[get(bundle: languageBundle, "favourite_movie.title")]
        let tableView = app.tables
        
        XCTAssertTrue(title.exists)
        XCTAssert(window.frame.contains(tableView.accessibilityFrame))
    }
    
    func testCategoryActionSheet() {
        app.launch()
        app.buttons[get(bundle: languageBundle, "home.button.category")].tap()
        
        XCTAssertTrue(app.sheets[get(bundle: languageBundle, "home.button.category")].exists)
    }
    
    func testCategoryActionSheetElements() {
        app.launch()
        app.buttons[get(bundle: languageBundle, "home.button.category")].tap()
        let sheet = app.sheets[get(bundle: languageBundle, "home.button.category")].scrollViews.otherElements
        let title = sheet.staticTexts[get(bundle: languageBundle, "home.button.category")]
        let cancelButton = sheet.buttons[get(bundle: languageBundle, "category.action.cancel")]
        let popularButton = sheet.buttons[get(bundle: languageBundle, "category.action.popular")]
        let upcomingButton = sheet.buttons[get(bundle: languageBundle, "category.action.upcoming")]
        let topRatedButton = sheet.buttons[get(bundle: languageBundle, "category.action.top_rated")]
        let nowPlayingButton = sheet.buttons[get(bundle: languageBundle, "category.action.now_playing")]

        XCTAssertTrue(title.exists)
        XCTAssertTrue(cancelButton.exists)
        XCTAssertTrue(popularButton.exists)
        XCTAssertTrue(upcomingButton.exists)
        XCTAssertTrue(topRatedButton.exists)
        XCTAssertTrue(nowPlayingButton.exists)
    }
    
    func testLaunchPerformance() {
        if #available(iOS 10.15, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
