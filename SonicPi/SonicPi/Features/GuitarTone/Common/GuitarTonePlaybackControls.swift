//
//  GuitarToneOutput.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 26/08/26.
//

import SwiftUI

struct GuitarTonePlaybackControls: View {
  let status: GuitarTonePlaybackStatus
  let output: any GuitarToneOutput

  var body: some View {
    VStack(spacing: 16) {
      Label(status.title, systemImage: status.symbolName)
        .font(.headline)
        .accessibilityLabel("Estado de audio: \(status.title)")

      Button("Preparar audio") {
        Task {
          await output.prepareAudioTapped()
        }
      }
      .buttonStyle(.borderedProminent)
      .accessibilityHint("Configura la cadena de audio para una pista que añadiremos después.")
      
      Button("Finalizar audio") {
        output.didEndingAudioTapped()
      }
      .buttonStyle(.borderedProminent)
      .accessibilityHint("Finaliza la cadena de sonido de la pista.")
    }
  }
}

#Preview {
  GuitarTonePlaybackControls(
    status: .idle,
    output: GuitarTonePlaybackControlsPreviewOutput()
  )
}
// Preview Class
@MainActor
private final class GuitarTonePlaybackControlsPreviewOutput: GuitarToneOutput {
  func prepareAudioTapped() {}
  func didEndingAudioTapped() {}
}
