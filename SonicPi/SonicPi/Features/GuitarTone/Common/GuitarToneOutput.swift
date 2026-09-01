//
//  GuitarToneOutput.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 26/08/26.
//


@MainActor
protocol GuitarToneOutput: AnyObject {
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
