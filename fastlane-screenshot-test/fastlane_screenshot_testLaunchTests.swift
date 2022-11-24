//
//  fastlane_screenshot_testLaunchTests.swift
//  fastlane-screenshot-test
//
//  Created by Luis Gonzalez on 23/11/22.
//

import XCTest

final class fastlane_screenshot_testLaunchTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testRegularWord() throws {
        let device = XCUIDevice.shared
        if UIDevice.current.userInterfaceIdiom == .phone {
            device.orientation = .portrait
        } else {
            device.orientation = .landscapeRight
        }
        
        snapshot("01BasicWord")

        // sleep(1)

        // let playButton = XCUIApplication().buttons["play"]
        // playButton.press(forDuration: 0.8);
        // snapshot("02PlaySpeed")
    }
}
