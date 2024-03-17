//
//  WorldOfPAYBACKUITests.swift
//  WorldOfPAYBACKUITests
//
//  Created by Hasan Parves on 30.01.24.
//

import XCTest

final class WorldOfPAYBACKUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testTransactionDetailsTransition() throws {
        let testBundle = Bundle(for: WorldOfPAYBACKUITests.self)
        let useMockData = testBundle.object(forInfoDictionaryKey: "USE_MOCK_DATA") as! Bool

        if useMockData {
            let suggestedDynamicsTitleText = app.staticTexts["Partner: Saturn"]
            let expectation = XCTWaiter().wait(for: [XCTestExpectation()], timeout: 4)
            if expectation == .timedOut {
                XCTAssertTrue(suggestedDynamicsTitleText.exists)
                suggestedDynamicsTitleText.tap()
                let detailsText = app.staticTexts["detailsText"]
                let detailsExpectation = XCTWaiter().wait(for: [XCTestExpectation()], timeout: 0.5)
                if detailsExpectation == .timedOut {
                    XCTAssertEqual(detailsText.label, "Description:\nPunkte sammeln", "mismatch" )
                    XCTAssertTrue(detailsText.exists)
                }
            }
        }
    }
    
    func testSideMenuTransition() throws {
        let sideMenuButton = app.buttons["side_menu_button"]
        sideMenuButton.tap()
        let expectation = XCTWaiter().wait(for: [XCTestExpectation()], timeout: 1)
        if expectation == .timedOut {
            let feedText = app.staticTexts["Feed"]
            XCTAssertTrue(feedText.exists)
            feedText.tap()
            let feedDetailsText = app.staticTexts["Feed Page"]
            XCTAssertTrue(feedDetailsText.exists)
        }
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
}
