//
//  GuitarToneViewModel.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 26/08/26.
//

import AVFAudio
import Foundation
import Observation
import GuitarToneLab

@Observable
final class GuitarToneViewModel {
  
  private let audioEngine: AudioEngineService
  
  private(set) var status: GuitarTonePlaybackStatus = .idle
  private(set) var equalizerSettings: EqualizerSettings = EqualizerSettings()
  private(set) var delaySettings: DelaySettings = DelaySettings()
  private(set) var reverbSettings: ReverbSettings = ReverbSettings()
  private(set) var metronomeSettings: MetronomeSettings?
  
  //Alert
  var showError: Bool = false
  var message: String = ""
  
  //Sheets
  var showEffect: EffectType?
  
  //MARK: - Init
  
  init(audioEngine: AudioEngineService = AudioEngineService()) {
    self.audioEngine = audioEngine
  }
  
  //MARK: - Methods
  
  func initialState() {
    verifyRecordPermissions()
    //TODO - setup UI services etc
  }
  
  //MARK: - verify recordPermissions
  
  private func verifyRecordPermissions() {
    switch AVAudioApplication.shared.recordPermission { // TODO set pertintents actions for those cases
    case .undetermined:
      debugPrint("Permission undetermined")
    case .denied:
      debugPrint("Permission denied by user")
    case .granted:
      debugPrint("Permissions Granted!")
    @unknown default:
      debugPrint("unknown record permissions")
    }
  }
  
  private func prepareSoundEngineGraph() {
    do {
      let inputInfo = audioEngine.currentAudioInputInfo()
      
      guard inputInfo.isAvailable else {
        showError = true
        message = "No audio input available"
        status = .error("No audio input available")
        return
      }
      audioEngine.prepareGraph()
      try audioEngine.startEngine()
      status = .ready
    } catch {
      showError = true
      message = error.localizedDescription
      status = .error(error.localizedDescription)
    }
  }
  
  private func updateEqualizerSettings(settings: EqualizerSettings) {
    equalizerSettings = settings
    audioEngine.apply(settings)
  }
  
  private func updateDelaySettings(settings: DelaySettings) {
    delaySettings = settings
    audioEngine.apply(settings)
  }
  
  private func updateReverbSettings(settings: ReverbSettings) {
    reverbSettings = settings
    audioEngine.apply(settings)
  }
  
  private func clearAllSettings() {
    audioEngine.clearEngine()
  }
}

//MARK: Guitar Tone Output

extension GuitarToneViewModel: GuitarToneOutput {
  
  func prepareAudioTapped() async {
    if await AVAudioApplication.requestRecordPermission() {
      prepareSoundEngineGraph()
    } else {
      showError = true
      message = "Permission denied by user"
      status = .error("Permission denied by user")
    }
  }
  
  
  func didToggleMetronome() {
    if metronomeSettings == nil {
      self.metronomeSettings = MetronomeSettings(bpm: 100, bitsPerMeasure: 4, volume: 0.7)
      guard let metronomeSettings else { return }
      audioEngine.startMetronome(with: metronomeSettings)
    } else {
      audioEngine.stopMetronome()
      metronomeSettings = nil
    }
  }

  func didEndingAudioTapped() {
    status = .finished
    audioEngine.endEngine()
  }
  
  func didShow(_ effect: EffectType) {
   showEffect = effect
  }
  
  func didHide() {
    showEffect = nil
  }
  
  func clearEffect(_ effect: EffectType) {
    switch effect {
      case .equalizer:
      audioEngine.clearEqualizer()
    case .delay:
      audioEngine.clearDelay()
    case .reverb:
      audioEngine.clearReverb()
    }
  }
  
  func equalizerSettingsChanged(_ settings: EqualizerSettings) {
    updateEqualizerSettings(settings: settings)
  }
  
  func delaySettingsChanged(_ settings: DelaySettings) {
    updateDelaySettings(settings: settings)
  }
  
  func reverbSettingsChanged(_ settings: ReverbSettings) {
    updateReverbSettings(settings: settings)
  }
}
