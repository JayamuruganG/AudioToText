//
//  SpeechToTextViewModelTests.swift
//  AudioTextTests
//
//  Created by Jayamurugan on 25/02/24.
//

import XCTest
@testable import AudioText

class SpeechToTextViewModelTests: XCTestCase {
    var viewModel: SpeechToTextViewModel!

    override func setUp() {
        super.setUp()
        viewModel = SpeechToTextViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testStartRecording() {
        viewModel.startRecording()
        XCTAssertTrue(viewModel.isRecording)
    }

    func testStopRecording() {
        viewModel.startRecording()
        viewModel.stopRecording()
        XCTAssertFalse(viewModel.isRecording)
    }

    func testCopyAllText() {
        let testText = "Test text"
        viewModel.recognizedText = testText
        viewModel.copyAllText()
        XCTAssertEqual(UIPasteboard.general.string, testText)
    }

    func testClearAllText() {
        viewModel.recognizedText = "Some text"
        viewModel.clearAllText()
        XCTAssertTrue(viewModel.recognizedText.isEmpty)
    }
}


