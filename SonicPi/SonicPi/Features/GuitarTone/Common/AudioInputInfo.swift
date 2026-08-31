//
//  AudioInputInfo.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 31/08/26.
//

struct AudioInputInfo: Equatable {
  let sampleRate: Double
  let channelCount: Int
  
  var isAvailable: Bool {
    return sampleRate > 0 && channelCount > 0
  }
}
