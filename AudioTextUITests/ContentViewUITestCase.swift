//
//  ContentViewUITestCase.swift
//  AudioTextUITests
//
//  Created by Jayamurugan on 25/02/24.
//

import XCTest
@testable import AudioText

class ContentViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testStartAndStopRecording() throws {
        let startRecordingButton = app.buttons["Start Recording"]
        XCTAssertTrue(startRecordingButton.exists)
        startRecordingButton.tap()
        let stopRecordingButton = app.buttons["Stop Recording"]
        XCTAssertTrue(stopRecordingButton.exists)
        stopRecordingButton.tap()
        XCTAssertTrue(startRecordingButton.exists)
    }

    func testCopyAllText() throws {
        let textEditor = app.textViews.element
        textEditor.tap() // Tap on the TextEditor to ensure it's focused
        let allText = textEditor.value as! String
        app.buttons["Copy All"].tap()
        XCTAssertEqual(UIPasteboard.general.string, allText)
    }

    func testClearAllText() throws {
        app.buttons["Clear All"].tap()
        let textEditor = app.textViews.element
        XCTAssertEqual(textEditor.value as! String, "")
    }
}
