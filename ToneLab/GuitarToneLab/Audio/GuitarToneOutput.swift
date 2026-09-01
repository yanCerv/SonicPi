//
//  GuitarToneOutput.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 26/08/26.
//

@MainActor
public protocol GuitarToneOutput: AnyObject {
  func prepareAudioTapped() async
  func didEndingAudioTapped()
  
  func didShowEqualizer()
  func didHideEqualizer()
  func didClearEqualizer()
  func equalizerSettingsChanged(_ settings: EqualizerSettings)
  
  func didShowDelay()
  func didHideDelay()
  func didClearDelay()
  func delaySettingsChanged(_ settings: DelaySettings)
  
  func didShowReverb()
  func didHideReverb()
  func didClearReverb()
  func reverbSettingsChanged(_ settings: ReverbSettings)
}

// Preview Class
@MainActor
public final class GuitarTonePlaybackControlsPreviewOutput: GuitarToneOutput {
  public init() {}
  public func prepareAudioTapped() {}
  public func didEndingAudioTapped() {}
  public func didShowEqualizer() {}
  public func didHideEqualizer() {}
  public func didClearEqualizer() {}
  public func equalizerSettingsChanged(_ settings: EqualizerSettings) {}
  public func didShowDelay() {}
  public func didHideDelay() {}
  public func didClearDelay() {}
  public func delaySettingsChanged(_ settings: DelaySettings) {}
  public func didShowReverb() {}
  public func didHideReverb() {}
  public func didClearReverb() {}
  public func reverbSettingsChanged(_ settings: ReverbSettings) {}
}
