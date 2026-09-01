//
//  DelaySettings.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 01/09/26.
//

import Foundation

public struct DelaySettings: Equatable {
  public let time: TimeInterval
  public let feedback: Float
  public let wetDryMix: Float

  public init(time: TimeInterval = 0, feedback: Float = 0, wetDryMix: Float = 0) {
    self.time = time
    self.feedback = feedback
    self.wetDryMix = wetDryMix
  }
}
