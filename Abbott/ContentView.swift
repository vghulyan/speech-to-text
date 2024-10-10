//
//  ContentView.swift
//  Abbott
//
//  Created by Vardan GHULYAN on 09/10/2024.
//

import SwiftUI
import AVFoundation
import Speech

struct ContentView: View {
    @State var conversation: [(String, Date)] = []
    @State var recording = false
    @State var recognizedText = ""
    @State var showWaveIcon = false
    @State var fromLanguage = "en"
    @State var toLanguage = "es"
    @State var editModeIndex: Int? = nil
    @State var showPopup = false
    @State var popupQuestion: String = ""
    @State var popupAnswer: String = ""
    let audioEngine = AVAudioEngine()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var speechRecognizer: SFSpeechRecognizer? {
        SFSpeechRecognizer(locale: Locale(identifier: fromLanguage))
    }

    var body: some View {
        NavigationView {
            VStack {
                LanguageSelectionView(fromLanguage: $fromLanguage, toLanguage: $toLanguage)
                HintSection()
                ConversationListView(conversation: $conversation, editModeIndex: $editModeIndex, showPopup: $showPopup, popupQuestion: $popupQuestion, popupAnswer: $popupAnswer, fromLanguage: fromLanguage, toLanguage: toLanguage)
                RecordButtonView(recording: $recording, showWaveIcon: $showWaveIcon, startRecording: startRecording, stopRecording: stopRecording)
            }
            .navigationTitle("Product Assistance")
            .alert(isPresented: $showPopup) {
                Alert(title: Text("Sending"), message: Text("Question: \(popupQuestion)\nAnswer: \(popupAnswer)"), dismissButton: .default(Text("OK")) {
                    showPopup = false
                })
            }
        }
        .onDisappear {
            stopRecording()
        }
    }
}



#Preview {
    ContentView()
}

//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
