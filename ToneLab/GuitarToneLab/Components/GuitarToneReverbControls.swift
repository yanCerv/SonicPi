//
//  GuitarToneReverbControls.swift
//  SonicPi
//
//  Created by Codex on 01/09/26.
//

import SwiftUI
import AVFoundation

public struct GuitarToneReverbControls: View {
  public let settings: ReverbSettings
  public let output: GuitarToneOutput

  public init(settings: ReverbSettings = ReverbSettings(), output: GuitarToneOutput) {
    self.settings = settings
    self.output = output
  }

  public var body: some View {
    GroupBox("Reverb") {
      VStack(alignment: .leading, spacing: 16) {
        Picker("Espacio", selection: presetBinding) {
          Text("Sala pequeña").tag(AVAudioUnitReverbPreset.smallRoom)
          Text("Sala mediana").tag(AVAudioUnitReverbPreset.mediumRoom)
          Text("Hall grande").tag(AVAudioUnitReverbPreset.largeHall)
          Text("Catedral").tag(AVAudioUnitReverbPreset.cathedral)
        }
        .pickerStyle(.menu)

        VStack(alignment: .leading, spacing: 6) {
          HStack {
            Text("Mezcla")
            Spacer()
            Text("\(wetDryMixBinding.wrappedValue, specifier: "%.0f") %")
              .foregroundStyle(.secondary)
              .monospacedDigit()
          }

          Slider(value: wetDryMixBinding, in: 0...100)
            .accessibilityLabel("Mezcla de señal seca y reverb")
        }

        Button("Listo") {
          output.didHide()
        }
        .buttonStyle(.borderedProminent)
        .frame(maxWidth: .infinity)
      }
    }
    .padding()
  }

  private var presetBinding: Binding<AVAudioUnitReverbPreset> {
    Binding(
      get: { settings.preset },
      set: { output.reverbSettingsChanged(makeSettings(preset: $0)) }
    )
  }

  private var wetDryMixBinding: Binding<Float> {
    Binding(
      get: { settings.wetDryMix },
      set: { output.reverbSettingsChanged(makeSettings(wetDryMix: $0)) }
    )
  }

  private func makeSettings(
    preset: AVAudioUnitReverbPreset? = nil,
    wetDryMix: Float? = nil
  ) -> ReverbSettings {
    ReverbSettings(
      preset: preset ?? settings.preset,
      wetDryMix: wetDryMix ?? settings.wetDryMix
    )
  }
}

#Preview {
  GuitarToneReverbControls(output: GuitarTonePlaybackControlsPreviewOutput())
}
