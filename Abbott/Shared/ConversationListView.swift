//
//  ConversationListView.swift
//  Abbott
//
//  Created by Vardan GHULYAN on 10/10/2024.
//
import SwiftUI
import AVFoundation // Needed for speech synthesis
import Foundation

struct ConversationListView: View {
    @Binding var conversation: [(String, Date)]
    @Binding var editModeIndex: Int?
    @Binding var showPopup: Bool
    @Binding var popupQuestion: String
    @Binding var popupAnswer: String
    var fromLanguage: String
    var toLanguage: String
    let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        List {
            ForEach(conversation.indices, id: \ .self) { index in
                VStack(alignment: .leading) {
                    if editModeIndex == index {
                        TextField("Edit Question", text: Binding(
                            get: { conversation[index].0 },
                            set: { newValue in
                                if newValue.hasPrefix("Question: ") {
                                    conversation[index].0 = newValue
                                } else {
                                    conversation[index].0 = "Question: " + newValue
                                }
                            }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 60) // Increased padding to make the confirm button more accessible when keyboard is shown
                        Button(action: {
                            let updatedQuestion = conversation[index].0.replacingOccurrences(of: "Question: ", with: "")
                            let newAnswer = searchAnswer(for: updatedQuestion) // Fetch updated answer based on the corrected question
                            let translatedAnswer = performTranslation(newAnswer.replacingOccurrences(of: "Answer: ", with: ""), from: "en", to: toLanguage)
                            let finalAnswer = "Answer: " + newAnswer
                            conversation[index].0 = "Question: \(updatedQuestion)"
                            if newAnswer != "I'm sorry, I do not have information on that question." {
                                conversation.insert((finalAnswer, Date()), at: index + 1)
                            }
                            editModeIndex = nil
                        }) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    } else {
                        HStack {
                            if conversation[index].0.starts(with: "Answer:") {
                                Button(action: {
                                    let answerLanguage: String
                                    if conversation[index].0.contains("¿Tienes un paracetamol?") || conversation[index].0.contains("¿Es bueno beber vodka?") {
                                        answerLanguage = "es"
                                    } else if conversation[index].0.contains("คุณมีพาราเซตามอลหรือไม่?") || conversation[index].0.contains("ดื่มวอดก้าดีไหม") {
                                        answerLanguage = "th-TH"
                                    } else {
                                        answerLanguage = "en"
                                    }
                                    configureAudioSessionForLoudspeaker()
                                    speakText(conversation[index].0, inLanguage: answerLanguage)
                                }) {
                                    Image(systemName: "speaker.wave.2.fill")
                                }
                            }
                            Text(conversation[index].0)
                                .disabled(conversation[index].0.starts(with: "Answer:")) // Prevent editing of the answer text
                            Spacer()
                            if conversation[index].0.starts(with: "Question:") {
                                Button(action: {
                                    editModeIndex = index
                                }) {
                                    Image(systemName: "pencil")
                                }
                            }
                        }
                        Text(conversation[index].1, style: .time)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    if !conversation[index].0.starts(with: "Question:") && index > 0 {
                        Button(action: {
                            popupQuestion = conversation[index - 1].0
                            popupAnswer = conversation[index].0
                            showPopup = true
                            sendToCloudServer(question: popupQuestion, answer: popupAnswer)
                        }) {
                            Label("Send", systemImage: "paperplane.fill")
                        }
                        .tint(.blue)
                    }
                }
            }
            .onDelete { indices in
                conversation.remove(atOffsets: indices)
            }
        }
    }

    private func speakText(_ text: String, inLanguage language: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.volume = 1.0 // Set volume to maximum for loudspeaker
        synthesizer.speak(utterance)
    }

    private func configureAudioSessionForLoudspeaker() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }
}
