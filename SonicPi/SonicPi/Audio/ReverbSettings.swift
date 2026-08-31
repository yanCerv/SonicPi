//
//  ReverbSettings.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 01/09/26.
//

import Foundation
import AVFAudio

struct ReverbSettings: Equatable {
  let preset: AVAudioUnitReverbPreset
  let wetDryMix: Float

  init(
    preset: AVAudioUnitReverbPreset = .largeHall,
    wetDryMix: Float = 0
  ) {
    self.preset = preset
    self.wetDryMix = wetDryMix
  }
}
