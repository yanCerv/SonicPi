//
//  AudioEngineService.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 31/08/26.
//

import AVFAudio

public final class AudioEngineService {
  private let engine = AVAudioEngine()
  private let player = AVAudioPlayerNode()
  private let mixer = AVAudioMixerNode()
  
  private let equalizer: AVAudioUnitEQ = AVAudioUnitEQ(numberOfBands: 3)
  private let delay: AVAudioUnitDelay = AVAudioUnitDelay()
  private let reverb: AVAudioUnitReverb = AVAudioUnitReverb()
  
  private var graphIsPrepared = false
  
  //MARK: - Init
  
  public init() { }

  //MARK: - Methods
  
  public func prepareGraph() {
    guard !graphIsPrepared else { return }

    let inputNode = engine.inputNode
    let inputFormat = inputNode.outputFormat(forBus: 0)
    let mainMixerNode = engine.mainMixerNode
    let reverbFormat = AVAudioFormat(standardFormatWithSampleRate: inputFormat.sampleRate, channels: 2)
    
    equalizer.auAudioUnit.maximumFramesToRender = 1_024
    delay.auAudioUnit.maximumFramesToRender = 1_024
    reverb.auAudioUnit.maximumFramesToRender = 1_024
    
    engine.attach(equalizer)
    engine.attach(delay)
    engine.attach(reverb)
    engine.attach(mixer)
    
    configureEqualizer()
    configureDelay()
    configureReverb()
    
    engine.connect(inputNode, to: equalizer, format: inputFormat)
    engine.connect(equalizer, to: delay, format: inputFormat)
    engine.connect(delay, to: mixer, format: inputFormat)
    engine.connect(mixer, to: reverb, format: reverbFormat)
    engine.connect(reverb, to: mainMixerNode, format: reverbFormat)
    
    engine.connect(mainMixerNode, to: engine.outputNode, format: nil)
        
    engine.prepare()
    graphIsPrepared = true
  }
  
  public func currentAudioInputInfo() -> AudioInputInfo {
    let input = engine.inputNode
    let format = input.inputFormat(forBus: 0)
    let channelCount = Int(format.channelCount)
    
    return AudioInputInfo(sampleRate: format.sampleRate, channelCount: channelCount)
  }
  
  public func startEngine() throws {
    try engine.start()
  }
  
  public func endEngine() {
    engine.stop()
  }
  
  public func clearEqualizer() {
    configureEqualizer()
  }
  
  public func clearDelay() {
    configureDelay()
  }
  
  public func clearReverb() {
    configureReverb()
  }
  
  public func clearEngine() {
    configureEqualizer()
    configureReverb()
    configureDelay()
  }
}

// MARK: - Equalizer

extension AudioEngineService {
  
  private func configureEqualizer() {
    let lowBand = equalizer.bands[0] // Low
    lowBand.filterType = .lowShelf
    lowBand.frequency = 120
    lowBand.bandwidth = 1
    lowBand.gain = 0
    lowBand.bypass = false

    let midBand = equalizer.bands[1] // Mid
    midBand.filterType = .parametric
    midBand.frequency = 1_000
    midBand.bandwidth = 1
    midBand.gain = 0
    midBand.bypass = false

    let highBand = equalizer.bands[2] // High
    highBand.filterType = .highShelf
    highBand.frequency = 5_000
    highBand.bandwidth = 1
    highBand.gain = 0
    highBand.bypass = false
  }
  
  public func apply(_ settings: EqualizerSettings) {
    equalizer.bands[0].gain = settings.low
    equalizer.bands[1].gain = settings.mid
    equalizer.bands[2].gain = settings.high
    
    engine.mainMixerNode.outputVolume = settings.outputVolume
  }
}

//MARK: - Delay

extension AudioEngineService {
  
  private func configureDelay() {
    delay.delayTime = 0
    delay.feedback = 0
    delay.lowPassCutoff = 12_000
    delay.wetDryMix = 0
    delay.bypass = false
  }
  
  public func apply(_ settings: DelaySettings) {
    delay.delayTime = settings.time
    delay.feedback = settings.feedback
    delay.wetDryMix = settings.wetDryMix
  }
}

//MARK: - Reverb

extension AudioEngineService {
  
  private func configureReverb() {
    reverb.loadFactoryPreset(.largeHall)
    reverb.wetDryMix = 0
    reverb.bypass = false
  }
  
  public func apply(_ settings: ReverbSettings) {
    reverb.loadFactoryPreset(settings.preset)
    reverb.wetDryMix = settings.wetDryMix
  }
}
