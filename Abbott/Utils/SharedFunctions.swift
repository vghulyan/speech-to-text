//
//  SharedFunctions.swift
//  Abbott
//
//  Created by Vardan GHULYAN on 10/10/2024.
//

import AVFoundation

func performTranslation(_ text: String, from sourceLanguage: String, to targetLanguage: String) -> String {
    print("Perform Translation \(text) - Source Language: \(sourceLanguage) - Target Language \(targetLanguage)")
    if sourceLanguage == "en" && targetLanguage == "es" {
        if text == "Do you have a paracetamol?" {
            return "¿Tienes un paracetamol?"
        } else if text == "Is it good to drink vodka?" {
            return "¿Es bueno beber vodka?"
        }
    } else if sourceLanguage == "en" && targetLanguage == "th-TH" {
        if text == "Do you have a paracetamol?" {
            return "คุณมีพาราเซตามอลหรือไม่?"
        } else if text == "Is it good to drink vodka?" {
            return "ดื่มวอดก้าดีไหม"
        }
    } else if sourceLanguage == "es" && targetLanguage == "en" {
        if text == "¿Tienes un paracetamol?" {
            return "Do you have a paracetamol?"
        } else if text == "¿Es bueno beber vodka?" {
            return "Is it good to drink vodka?"
        }
    } else if sourceLanguage == "th-TH" && targetLanguage == "en" {
        if text == "คุณมีพาราเซตามอลหรือไม่?" {
            return "Do you have a paracetamol?"
        } else if text == "ดื่มวอดก้าดีไหม" {
            return "Is it good to drink vodka?"
        }
    } else if sourceLanguage == "es" && targetLanguage == "th-TH" {
        if text == "¿Tienes un paracetamol?" {
            return "คุณมีพาราเซตามอลหรือไม่?"
        } else if text == "¿Es bueno beber vodka?" {
            return "ดื่มวอดก้าดีไหม"
        }
    } else if sourceLanguage == "th-TH" && targetLanguage == "es" {
        if text == "คุณมีพาราเซตามอลหรือไม่?" {
            return "¿Tienes un paracetamol?"
        } else if text == "ดื่มวอดก้าดีไหม" {
            return "¿Es bueno beber vodka?"
        }
    }
    print("Perform translation \(text)")
    return text
}

// MARK: - Translation Function
func translateText(_ text: String, from sourceLanguage: String, to targetLanguage: String) -> String {
    let translationDictionary: [String: [String: String]] = [
        "Do you have a paracetamol?": [
            "es": "¿Tienes un paracetamol?",
            "th-TH": "คุณมีพาราเซตามอลหรือไม่?"
        ],
        "Is it good to drink vodka?": [
            "es": "¿Es bueno beber vodka?",
            "th-TH": "ดื่มวอดก้าดีไหม"
        ]
    ]

    if let translations = translationDictionary[text], let translatedText = translations[targetLanguage] {
        return translatedText
    }

    return text
}

// MARK: - Search Answer Function
func searchAnswer(for question: String) -> String {
    print("Question \(question)")
    let answersRepository = [
        "do you have a paracetamol": [
            "en": "Do you have a paracetamol?",
            "th-TH": "คุณมีพาราเซตามอลหรือไม่?",
            "es": "¿Tienes un paracetamol?"
        ],
        "is it good to drink vodka": [
            "en": "Is it good to drink vodka?",
            "th-TH": "ดื่มวอดก้าดีไหม",
            "es": "¿Es bueno beber vodka?"
        ]
    ]

    let lowercasedQuestion = question.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    if let answerDict = answersRepository[lowercasedQuestion], let answer = answerDict["en"] {
        print("Search answer result: \(answer)")
        return answer
    }

    return "Answer: I'm sorry, I do not have information on that question."
}

// MARK: - Speak Text Function
func speakText(_ text: String, inLanguage language: String) {
    let utterance = AVSpeechUtterance(string: text)
    utterance.voice = AVSpeechSynthesisVoice(language: language)
    utterance.volume = 1.0 // Set volume to maximum for loudspeaker
    let synthesizer = AVSpeechSynthesizer()
    synthesizer.speak(utterance)
}


// MARK: - Send to Cloud Server Function
func sendToCloudServer(question: String, answer: String) {
    let url = URL(string: "https://dummyapi.com/send")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: Any] = [
        "question": question,
        "answer": answer
    ]

    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
    } catch {
        print("Error serializing JSON: \(error.localizedDescription)")
        return
    }

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error sending data to server: \(error.localizedDescription)")
            return
        }
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            print("Successfully sent data to server.")
        } else {
            print("Failed to send data to server.")
        }
    }
    task.resume()
}
