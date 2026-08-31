//
//  GuitarToneEqulizerControls.swift
//  SonicPi
//
//  Created by Yan Cervantes on 31/08/26.
//

import SwiftUI

struct GuitarToneEqualizerControls: View {
  
  let settings: EqualizerSettings
  let output: GuitarToneOutput
  
  private var lowGainBinding: Binding<Float> {
    Binding(
      get: { settings.low },
      set: { output.equalizerSettingsChanged(makeSettings(low: $0)) }
    )
  }
  
  private var midGainBinding: Binding<Float> {
    Binding(
      get: { settings.mid },
      set: { output.equalizerSettingsChanged(makeSettings(mid: $0)) }
    )
  }
  
  private var highGainBinding: Binding<Float> {
    Binding(
      get: { settings.high },
      set: { output.equalizerSettingsChanged(makeSettings(high: $0)) }
    )
  }
  
  private var volumeBinding: Binding<Float> {
    Binding(
      get: { settings.outputVolume },
      set: { output.equalizerSettingsChanged(makeSettings(outputVolume: $0)) }
    )
  }
  
  init(settings: EqualizerSettings = EqualizerSettings(), output: GuitarToneOutput) {
    self.settings = settings
    self.output = output
  }
  
  var body: some View {
    VStack(alignment: .center, spacing: 6) {
      GroupBox("Ecualizador") {
        EqualizerGainControl(title: "Bajos", value: lowGainBinding)
        EqualizerGainControl(title: "Medios", value: midGainBinding)
        EqualizerGainControl(title: "Altos", value: highGainBinding)
        volumeControl
        
        Button("Listo") {
          output.didHideEqualizer()
        }
        .buttonStyle(.borderedProminent)
        .accessibilityHint("Aceptar y guardar configuraciones seleccionadas.")
      }
      .padding()

    }
  }
  
  private var volumeControl: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack {
        Text("Volumen")
        Spacer()
        Text("\(volumeBinding.wrappedValue * 100, specifier: "%.0f") %")
          .foregroundStyle(.secondary)
          .monospacedDigit()
      }
      
      Slider(value: volumeBinding, in: 0...1)
        .accessibilityLabel("Volumen de salida")
    }
  }
  
  private func makeSettings(low: Float? = nil, mid: Float? = nil, high: Float? = nil, outputVolume: Float? = nil) -> EqualizerSettings {
    EqualizerSettings(
      low: low ?? settings.low,
      mid: mid ?? settings.mid,
      high: high ?? settings.high,
      outputVolume: outputVolume ?? settings.outputVolume
    )
  }
}

#Preview {
  GuitarToneEqualizerControls(output: GuitarTonePlaybackControlsPreviewOutput())
}
