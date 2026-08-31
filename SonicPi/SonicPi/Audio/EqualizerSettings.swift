//
//  EqualizerSettings.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 31/08/26.
//

struct EqualizerSettings: Equatable {
  let low: Float
  let mid: Float
  let high: Float
  let outputVolume: Float
  
  init(low: Float = 0, mid: Float = 0, high: Float = 0, outputVolume: Float = 1) {
    self.low = low
    self.mid = mid
    self.high = high
    self.outputVolume = outputVolume
  }
}
