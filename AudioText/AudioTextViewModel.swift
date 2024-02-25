//
//  AudioTextViewModel.swift
//  AudioText
//
//  Created by Jayamurugan on 25/02/24.
//

import SwiftUI
import Speech

class SpeechToTextViewModel: ObservableObject {
  @Published var recognizedText = ""
  @Published var isRecording = false
  private var audioEngine = AVAudioEngine()
  private var recognizer: SFSpeechRecognizer?
  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  private var recognitionTask: SFSpeechRecognitionTask?

  func startRecording() {
    recognizedText = ""
    isRecording = true

    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
      try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    } catch {
      print("Failed to set up audio session")
      return
    }

    recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    guard let recognitionRequest = recognitionRequest else {
      print("Unable to create recognition request")
      return
    }

    let inputNode = audioEngine.inputNode



    recognitionTask = recognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
      guard let self = self else { return }
      if let result = result {
        self.recognizedText = result.bestTranscription.formattedString
      } else if let error = error {
        print("Recognition error: \(error)")
      }
    }

    let recordingFormat = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
      recognitionRequest.append(buffer)
    }

    audioEngine.prepare()
    do {
      try audioEngine.start()
    } catch {
      print("Audio engine failed to start")
    }
  }

  func stopRecording() {
    isRecording = false
    audioEngine.stop()
    audioEngine.inputNode.removeTap(onBus: 0)
    recognitionRequest?.endAudio()
    recognitionTask?.cancel()
  }

  func requestSpeechAuthorization() {
    SFSpeechRecognizer.requestAuthorization { authStatus in
      switch authStatus {
      case .authorized:
        print("Speech recognition authorized")
      case .denied:
        print("User denied access to speech recognition")
      case .restricted:
        print("Speech recognition restricted on this device")
      case .notDetermined:
        print("Speech recognition not yet authorized")
      @unknown default:
        print("Unknown speech recognition authorization status")
      }
    }
  }

  func copyAllText() {
    UIPasteboard.general.string = recognizedText
    print("Text copied to clipboard: \(recognizedText)")
  }

  func clearAllText() {
    recognizedText = ""
  }
}
