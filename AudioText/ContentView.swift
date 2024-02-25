//
//  ContentView.swift
//  AudioText
//
//  Created by Jayamurugan on 25/02/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SpeechToTextViewModel()
    @State private var copiedTextAlert = false

    var body: some View {
        VStack {
            TextEditor(text: $viewModel.recognizedText)
                .padding()
                .disabled(true)
                .onTapGesture {
                    viewModel.copyAllText()
                }

            HStack {
                Button(action: {
                    if viewModel.isRecording {
                        viewModel.stopRecording()
                    } else {
                        viewModel.startRecording()
                    }
                }) {
                    Text(viewModel.isRecording ? "Stop Recording" : "Start Recording")
                        .padding()
                }

                Button(action: {
                    copyText()
                }) {
                    Text("Copy All")
                        .padding()
                }

              Button(action: {
                  viewModel.clearAllText()
              }) {
                  Text("Clear All")
                      .padding()
              }
            }
        }
        .alert(isPresented: $copiedTextAlert) {
            Alert(title: Text("Text Copied"), message: Text("The text has been copied to the clipboard."), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            viewModel.requestSpeechAuthorization()
        }
    }

    private func copyText() {
        UIPasteboard.general.string = viewModel.recognizedText
        copiedTextAlert = true
    }
}

#Preview {
    ContentView()
}
