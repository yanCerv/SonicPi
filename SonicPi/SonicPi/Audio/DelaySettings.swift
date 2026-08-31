//
//  DelaySettings.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 01/09/26.
//

import Foundation

struct DelaySettings: Equatable {
  let time: TimeInterval
  let feedback: Float
  let wetDryMix: Float

  init(
    time: TimeInterval = 0,
    feedback: Float = 0,
    wetDryMix: Float = 0
  ) {
    self.time = time
    self.feedback = feedback
    self.wetDryMix = wetDryMix
  }
}
