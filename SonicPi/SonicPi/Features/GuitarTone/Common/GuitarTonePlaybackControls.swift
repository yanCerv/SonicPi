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

// Preview Class
@MainActor
final class GuitarTonePlaybackControlsPreviewOutput: GuitarToneOutput {
  func prepareAudioTapped() {}
  func didEndingAudioTapped() {}
  
  func didShowEqualizer() {}
  func didHideEqualizer() {}
  func equalizerSettingsChanged(_ settings: EqualizerSettings) {}
  
  func didShowDelay() {}
  func didHideDelay() {}
  func delaySettingsChanged(_ settings: DelaySettings) {}
  
  func didShowReverb() {}
  func didHideReverb() {}
  func reverbSettingsChanged(_ settings: ReverbSettings) {}
}
