//
//  LanguageSelectionView.swift
//  Abbott
//
//  Created by Vardan GHULYAN on 10/10/2024.
//

import SwiftUI

struct LanguageSelectionView: View {
    @Binding var fromLanguage: String
    @Binding var toLanguage: String

    let languages: [(String, String)] = [
        ("English", "en"),
        ("Spanish", "es"),
        ("Thai", "th-TH")
    ]

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(LocalizedStringKey("From Language"))
                    .font(.headline)
                Picker(LocalizedStringKey("From Language"), selection: $fromLanguage) {
                    ForEach(languages, id: \ .1) { language in
                        Text(LocalizedStringKey(language.0)).tag(language.1)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding()

            VStack(alignment: .leading) {
                Text(LocalizedStringKey("To Language"))
                    .font(.headline)
                Picker(LocalizedStringKey("To Language"), selection: $toLanguage) {
                    ForEach(languages, id: \ .1) { language in
                        Text(LocalizedStringKey(language.0)).tag(language.1)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding()
        }
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .padding()
    }
}
