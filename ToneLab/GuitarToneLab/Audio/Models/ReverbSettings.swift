//
//  ReverbSettings.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 01/09/26.
//

import Foundation
import AVFAudio

public struct ReverbSettings: Equatable {
  public let preset: AVAudioUnitReverbPreset
  public let wetDryMix: Float

  public init(preset: AVAudioUnitReverbPreset = .largeHall, wetDryMix: Float = 0) {
    self.preset = preset
    self.wetDryMix = wetDryMix
  }
}
