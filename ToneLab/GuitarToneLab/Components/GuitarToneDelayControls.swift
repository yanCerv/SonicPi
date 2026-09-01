//
//  GuitarToneDelayControls.swift
//  SonicPi
//
//  Created by Yan Cervantes on 01/09/26.
//

import SwiftUI

public struct GuitarToneDelayControls: View {
  public let settings: DelaySettings
  public let output: GuitarToneOutput

  public init(settings: DelaySettings = DelaySettings(), output: GuitarToneOutput) {
    self.settings = settings
    self.output = output
  }

  public var body: some View {
    GroupBox("Delay") {
      VStack(alignment: .leading, spacing: 16) {
        timeControl
        percentageControl(
          title: "Feedback",
          value: feedbackBinding,
          accessibilityLabel: "Feedback del delay"
        )
        percentageControl(
          title: "Mezcla",
          value: wetDryMixBinding,
          accessibilityLabel: "Mezcla de señal seca y delay"
        )

        Button("Listo") {
          output.didHideDelay()
        }
        .buttonStyle(.borderedProminent)
        .frame(maxWidth: .infinity)
      }
    }
    .padding()
  }

  private var timeBinding: Binding<TimeInterval> {
    Binding(
      get: { settings.time },
      set: { output.delaySettingsChanged(makeSettings(time: $0)) }
    )
  }

  private var feedbackBinding: Binding<Float> {
    Binding(
      get: { settings.feedback },
      set: { output.delaySettingsChanged(makeSettings(feedback: $0)) }
    )
  }

  private var wetDryMixBinding: Binding<Float> {
    Binding(
      get: { settings.wetDryMix },
      set: { output.delaySettingsChanged(makeSettings(wetDryMix: $0)) }
    )
  }

  private var timeControl: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack {
        Text("Tiempo")
        Spacer()
        Text("\(timeBinding.wrappedValue, specifier: "%.2f") s")
          .foregroundStyle(.secondary)
          .monospacedDigit()
      }

      Slider(value: timeBinding, in: 0...2)
        .accessibilityLabel("Tiempo del delay")
    }
  }

  private func percentageControl(
    title: String,
    value: Binding<Float>,
    accessibilityLabel: String
  ) -> some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack {
        Text(title)
        Spacer()
        Text("\(value.wrappedValue, specifier: "%.0f") %")
          .foregroundStyle(.secondary)
          .monospacedDigit()
      }

      Slider(value: value, in: 0...100)
        .accessibilityLabel(accessibilityLabel)
    }
  }

  private func makeSettings(
    time: TimeInterval? = nil,
    feedback: Float? = nil,
    wetDryMix: Float? = nil
  ) -> DelaySettings {
    DelaySettings(
      time: time ?? settings.time,
      feedback: feedback ?? settings.feedback,
      wetDryMix: wetDryMix ?? settings.wetDryMix
    )
  }
}

#Preview {
  GuitarToneDelayControls(output: GuitarTonePlaybackControlsPreviewOutput())
}
