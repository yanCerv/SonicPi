//
//  MetronomeSettings.swift
//  GuitarToneLab
//
//  Created by Yan Cervantes  on 01/09/26.
//

public struct MetronomeSettings: Equatable {
  public let bpm: Double // 120 bpm
  public let bitsPerMeasure: Double // compas 4/4 - 6/8
  public let volume: Float
  
  public init(bpm: Double, bitsPerMeasure: Double, volume: Float) {
    self.bpm = bpm
    self.bitsPerMeasure = bitsPerMeasure
    self.volume = volume
  }
}
