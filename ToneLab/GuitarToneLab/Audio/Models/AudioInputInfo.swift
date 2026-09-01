//
//  AudioInputInfo.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 31/08/26.
//

public struct AudioInputInfo: Equatable {
  public let sampleRate: Double
  public let channelCount: Int
  
  public var isAvailable: Bool {
    return sampleRate > 0 && channelCount > 0
  }
  
  public init(sampleRate: Double, channelCount: Int) {
    self.sampleRate = sampleRate
    self.channelCount = channelCount
  }
}
