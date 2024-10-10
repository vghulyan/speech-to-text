//
//  RecordButtonView.swift
//  Abbott
//
//  Created by Vardan GHULYAN on 10/10/2024.
//

import SwiftUI

struct RecordButtonView: View {
    @Binding var recording: Bool
    @Binding var showWaveIcon: Bool
    var startRecording: () -> Void
    var stopRecording: () -> Void

    var body: some View {
        Button(action: {
            if recording {
                stopRecording()
            } else {
                startRecording()
            }
        }) {
            VStack {
                Image(systemName: "waveform.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(showWaveIcon ? .green : .gray)
                    .animation(.easeInOut, value: showWaveIcon)
                Text(recording ? "Stop Recording" : "Ask a Question")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
