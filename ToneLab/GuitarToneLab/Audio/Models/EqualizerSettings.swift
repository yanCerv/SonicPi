//
//  EqualizerSettings.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 31/08/26.
//

public struct EqualizerSettings: Equatable {
  public let low: Float
  public let mid: Float
  public let high: Float
  public let outputVolume: Float
  
  public init(low: Float = 0, mid: Float = 0, high: Float = 0, outputVolume: Float = 1) {
    self.low = low
    self.mid = mid
    self.high = high
    self.outputVolume = outputVolume
  }
}
