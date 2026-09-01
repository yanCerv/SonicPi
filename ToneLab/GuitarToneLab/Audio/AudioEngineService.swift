//
//  AudioEngineService.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 31/08/26.
//

import AVFAudio

public final class AudioEngineService {
  private let engine = AVAudioEngine()
  private let metronomePlayer = AVAudioPlayerNode()
  private let mixer = AVAudioMixerNode()
  
  private let equalizer: AVAudioUnitEQ = AVAudioUnitEQ(numberOfBands: 3)
  private let delay: AVAudioUnitDelay = AVAudioUnitDelay()
  private let reverb: AVAudioUnitReverb = AVAudioUnitReverb()
  
  private var metronomeFormat: AVAudioFormat?
  private var metronomeBuffer: AVAudioPCMBuffer?
  
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
    
    metronomeFormat = reverbFormat
    metronomeBuffer = setupMetronomeClickBuffer(whit: reverbFormat)
      
    equalizer.auAudioUnit.maximumFramesToRender = 1_024
    delay.auAudioUnit.maximumFramesToRender = 1_024
    reverb.auAudioUnit.maximumFramesToRender = 1_024
    
    engine.attach(equalizer)
    engine.attach(delay)
    engine.attach(reverb)
    engine.attach(mixer)
    engine.attach(metronomePlayer)
    
    configureEqualizer()
    configureDelay()
    configureReverb()
    
    // Effects
    engine.connect(inputNode, to: equalizer, format: inputFormat)
    engine.connect(equalizer, to: delay, format: inputFormat)
    engine.connect(delay, to: mixer, format: inputFormat)
    engine.connect(mixer, to: reverb, format: reverbFormat)
    engine.connect(reverb, to: mainMixerNode, format: reverbFormat)
    
    // Player - metronome
    engine.connect(metronomePlayer, to: mainMixerNode, format: reverbFormat)
    
    // Mixer
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

//MARK: - Metronome

extension AudioEngineService {
  private func setupMetronomeClickBuffer(whit format: AVAudioFormat?) -> AVAudioPCMBuffer? {
    guard let format else { return nil }
    let duration = 0.03
    let frequency = 1_000.0
    let frameCount = AVAudioFrameCount(format.sampleRate * duration)
    
    guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount),
    let channelData = buffer.floatChannelData else { return nil }
    
    buffer.frameLength = frameCount
    let counter = Int(frameCount)
    
    for frame in 0..<counter {
      let time = Double(frame) / format.sampleRate
      let envelope = 1 - (time / duration)
      let sin = sin(2 * .pi * frequency * time) * envelope * 0.35
      let sample = Float(sin)
      
      for channel in 0..<Int(format.channelCount) {
        channelData[channel][frame] = sample
      }
    }
    
    return buffer
  }
  
  //Helper
  private func makeMetronomyBeatBuffer(settings: MetronomeSettings, format: AVAudioFormat, clickBuffer: AVAudioPCMBuffer) -> AVAudioPCMBuffer? {
    guard settings.bpm > 0 else { return nil }
    
    let secondsPerBeat = 60 / settings.bpm
    let frameCount = AVAudioFrameCount(format.sampleRate * secondsPerBeat)
    
    guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount),
          let beatData = buffer.floatChannelData,
          let clickData = clickBuffer.floatChannelData else { return nil }
    
    
    buffer.frameLength = frameCount
    let clickBufferCount = Int(clickBuffer.frameLength)
    let frameCounter = Int(frameCount)
    let channelCount = Int(format.channelCount)
    
    let copiedFrameCount = min(clickBufferCount, frameCounter)
    for channel in 0..<channelCount {
      for frame in 0..<frameCounter {
        beatData[channel][frame] = 0
      }
      
      for frame in 0..<copiedFrameCount {
        beatData[channel][frame] = clickData[channel][frame]
      }
    }
    
    return buffer
  }
  
  public func startMetronome(with settings: MetronomeSettings) {
    guard let metronomeFormat,
          let clickBuffer = metronomeBuffer,
          let beatBuffer = makeMetronomyBeatBuffer(settings: settings, format: metronomeFormat, clickBuffer: clickBuffer) else { return }
        
    metronomePlayer.stop()
    metronomePlayer.volume = settings.volume
    metronomePlayer.scheduleBuffer(beatBuffer, at: nil, options: .loops)
    metronomePlayer.play()
  }
  
  public func stopMetronome() {
    metronomePlayer.stop()
  }
}
