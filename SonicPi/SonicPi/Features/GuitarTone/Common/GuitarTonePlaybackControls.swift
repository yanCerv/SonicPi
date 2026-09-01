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
            output.didShow(.equalizer)
          }
          .buttonStyle(.borderedProminent)
          .accessibilityHint("Muestra el ecualizador de tres bandas y volumen.")

          Button("Delay") {
            output.didShow(.delay)
          }
          .buttonStyle(.borderedProminent)
          .accessibilityHint("Muestra los controles de repetición del delay.")

          Button("Reverb") {
            output.didShow(.reverb)
          }
          .buttonStyle(.borderedProminent)
          .accessibilityHint("Muestra los controles de espacio y mezcla de reverb.")
          
          Button("Finalizar audio") {
            output.didEndingAudioTapped()
          }
          .foregroundStyle(.red)
          .buttonStyle(.bordered)
          .accessibilityHint("Finaliza la cadena de sonido de la pista.")
        }
        
        Button("Metronomo") {
          output.didToggleMetronome()
        }
        .buttonStyle(.borderedProminent)
        .accessibilityHint("Inicia un metronomo con un bit predeterminado o configurado.")
      }
    }
  }
}

#Preview {
  GuitarTonePlaybackControls(status: .idle, output: GuitarTonePlaybackControlsPreviewOutput())
}
