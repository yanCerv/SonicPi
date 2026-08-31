//
//  AudioEngineService.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 31/08/26.
//

import AVFAudio
import Accelerate

final class AudioEngineService {
  private let engine = AVAudioEngine()
  private let player = AVAudioPlayerNode()
  private let mixer = AVAudioMixerNode()
  
  private var graphIsPrepared = false

  func prepareGraph() {
    guard !graphIsPrepared else { return }

    let inputNode = engine.inputNode
    let format = inputNode.inputFormat(forBus: 0)
    let mainMixerNode = engine.mainMixerNode
    
    engine.connect(inputNode, to: engine.outputNode, format: nil)
    engine.prepare()
    graphIsPrepared = true
  }
  
  func currentAudioInputInfo() -> AudioInputInfo {
    let input = engine.inputNode
    let format = input.inputFormat(forBus: 0)
    let channelCount = Int(format.channelCount)
    
    return AudioInputInfo(sampleRate: format.sampleRate, channelCount: channelCount)
  }
  
  func startEngine() throws {
    try engine.start()
  }
  
  func endEngine() {
    engine.stop()
  }
}
