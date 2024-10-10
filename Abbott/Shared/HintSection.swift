//
//  HintSection.swift
//  Abbott
//
//  Created by Vardan GHULYAN on 10/10/2024.
//

import SwiftUI

struct HintSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hints")
                .font(.headline)
                .padding(.top)
            Text("- Do you have a paracetamol?")
            Text("- Is it good to drink vodka?")
        }
        .padding()
    }
}
