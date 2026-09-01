//
//  GuitarToneOutput.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 26/08/26.
//

import SwiftUI
import GuitarToneLab

struct GuitarTonePlaybackControls: View {
  let status: GuitarTonePlaybackStatus
  let output: GuitarToneOutput

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
      
      if status == .ready {
        HStack(spacing: 6) {
          Button("Ecualizador") {
            output.didShowEqualizer()
          }
          .buttonStyle(.borderedProminent)
          .accessibilityHint("Muestra el ecualizador de tres bandas y volumen.")

          Button("Delay") {
            output.didShowDelay()
          }
          .buttonStyle(.borderedProminent)
          .accessibilityHint("Muestra los controles de repetición del delay.")

          Button("Reverb") {
            output.didShowReverb()
          }
          .buttonStyle(.borderedProminent)
          .accessibilityHint("Muestra los controles de espacio y mezcla de reverb.")
          
          Button("Finalizar audio") {
            output.didEndingAudioTapped()
          }
          .foregroundStyle(.red)
          .buttonStyle(.borderedProminent)
          .accessibilityHint("Finaliza la cadena de sonido de la pista.")
        }
      }
    }
  }
}

#Preview {
  GuitarTonePlaybackControls(status: .idle, output: GuitarTonePlaybackControlsPreviewOutput())
}
