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
  
  //Alert
  var showError: Bool = false
  var message: String = ""
  
  //Sheets
  var showEqualizer: Bool = false
  var showDelay: Bool = false
  var showReverb: Bool = false
  
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
  
  func didEndingAudioTapped() {
    status = .finished
    audioEngine.endEngine()
  }
}

//MARK: - Equalizer Output - already set on first extension Mark

extension GuitarToneViewModel {
  func didShowEqualizer() {
    showEqualizer = true
  }
  
  func didHideEqualizer() {
    showEqualizer = false
  }
  
  func didClearEqualizer() {
    audioEngine.clearEqualizer()
  }
  
  func equalizerSettingsChanged(_ settings: EqualizerSettings) {
    updateEqualizerSettings(settings: settings)
  }
}

//MARK: - Delay Output - already set on first extension Mark

extension GuitarToneViewModel {
  func didShowDelay() {
    showDelay = true
  }
  
  func didHideDelay() {
    showDelay = false
  }
  
  func didClearDelay() {
    audioEngine.clearDelay()
  }
  
  func delaySettingsChanged(_ settings: DelaySettings) {
    updateDelaySettings(settings: settings)
  }
}

//MARK: - Reverb Output - already set on first extension Mark

extension GuitarToneViewModel {
  func didShowReverb() {
    showReverb = true
  }
  
  func didHideReverb() {
    showReverb = false
  }
  
  func didClearReverb() {
    audioEngine.clearReverb()
  }
  
  func reverbSettingsChanged(_ settings: ReverbSettings) {
    updateReverbSettings(settings: settings)
  }
}
