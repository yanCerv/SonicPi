//
//  GuitarToneOutput.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 26/08/26.
//

public enum EffectType: String, Identifiable {
  case equalizer
  case delay
  case reverb
  
  public var id: String {
    return self.rawValue
  }
}

@MainActor
public protocol GuitarToneOutput: AnyObject {
  func prepareAudioTapped() async
  func didEndingAudioTapped()
  
  func didToggleMetronome()
  
  func didShow(_ effect: EffectType)
  func didHide()
  func clearEffect(_ effect: EffectType)
  
  func equalizerSettingsChanged(_ settings: EqualizerSettings)
  func delaySettingsChanged(_ settings: DelaySettings)
  func reverbSettingsChanged(_ settings: ReverbSettings)
}

// Preview Class
@MainActor
public final class GuitarTonePlaybackControlsPreviewOutput: GuitarToneOutput {
  public init() {}
  
  public func prepareAudioTapped() {}
  public func didEndingAudioTapped() {}
  
  public func didToggleMetronome() {}
  
  public func didShow(_ effect: EffectType) {}
  public func didHide() {}
  public func clearEffect(_ effect: EffectType) {}
  
  public func equalizerSettingsChanged(_ settings: EqualizerSettings) {}
  public func delaySettingsChanged(_ settings: DelaySettings) {}
  public func reverbSettingsChanged(_ settings: ReverbSettings) {}
}
