//
//  Untitled.swift
//  Abbott
//
//  Created by Vardan GHULYAN on 10/10/2024.
//

import Speech
import AVFoundation

extension ContentView {
    func startRecording() {
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            case .authorized:
                break
            default:
                return
            }
        }

        let audioSession = AVAudioSession.sharedInstance()
        do {
            // Set the audio session category to record and playback, and set the mode to measurement.
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session setup failed: \(error.localizedDescription)")
            return
        }

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        // Ensure that the format sample rate matches the hardware sample rate.
        guard recordingFormat.sampleRate == audioSession.sampleRate else {
            print("Sample rate mismatch: Recording format sample rate does not match audio session sample rate.")
            return
        }

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }

        audioEngine.prepare()

        do {
            try audioEngine.start()
            showWaveIcon = true
            speechRecognizer?.recognitionTask(with: request) { result, error in
                if let result = result, result.isFinal {
                    self.recognizedText = result.bestTranscription.formattedString
                    processQuestion(self.recognizedText)
                } else if let error = error {
                    print("Error recognizing speech: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }

        recording = true
    }


    func stopRecording() {
        audioEngine.stop()
        request.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        recording = false
        showWaveIcon = false
    }

    private func processQuestion(_ question: String) {
        print("Process Question - question \(question)")
        let standardizedQuestion = question.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        print("Process Question - standardized question \(standardizedQuestion)")

        let response = searchAnswer(for: standardizedQuestion)
        print("Process Question - response \(response)")

        if response != "Answer: I'm sorry, I do not have information on that question." {
            let translatedResponse = translateText(response, from: "en", to: toLanguage)
            conversation.insert(("Question: \(question)", Date()), at: 0)
            conversation.insert(("Answer: \(translatedResponse)", Date()), at: 1)
        } else {
            conversation.insert(("Question: \(question)", Date()), at: 0)
            conversation.insert((response, Date()), at: 1)
        }
    }
}

