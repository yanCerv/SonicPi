//
//  EqualizerGainControl.swift
//  SonicPi
//
//  Created by Yan Cervantes on 31/08/26.
//

import SwiftUI

public struct EqualizerGainControl: View {
  
  public let title: String
  public let value: Binding<Float>
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack {
        Text(title)
        Spacer()
        Text("\(value.wrappedValue, specifier: "%.1f") dB")
          .foregroundStyle(.secondary)
          .monospacedDigit()
      }
      
      Slider(value: value, in: -12...12)
        .accessibilityLabel(title)
    }
  }
}

#Preview {
  EqualizerGainControl(title: "Gain", value: .constant(0.5))
}
