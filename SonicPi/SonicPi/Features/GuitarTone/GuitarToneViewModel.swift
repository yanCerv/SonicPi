//
//  GuitarToneViewModel.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 26/08/26.
//

import Foundation
import AVFAudio
import Observation

@Observable
final class GuitarToneViewModel {
  private let audioEngine: AudioEngineService
  private(set) var status: GuitarTonePlaybackStatus = .idle
  
  //Alert
  var showError: Bool = false
  var message: String = ""

  //MARK: Init
  
  init(audioEngine: AudioEngineService = AudioEngineService()) {
    self.audioEngine = audioEngine
  }
  
  //MARK: Methods
  
  func initialState() {
    verifyRecordPermissions()
    //TODO - setup UI services etc
  }
  
  //MARK: - verify recordPermissions
  
  private func verifyRecordPermissions() {
    switch AVAudioApplication.shared.recordPermission {
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
      audioEngine.prepareGraph()
      let inputInfo = audioEngine.currentAudioInputInfo()
      
      guard inputInfo.isAvailable else {
        showError = true
        message = "No audio input available"
        status = .error("No audio input available")
        return
      }
      debugPrint(inputInfo)
      try audioEngine.startEngine()
      status = .ready
    } catch {
      showError = true
      message = error.localizedDescription
      status = .error(error.localizedDescription)
    }
  }
}

//MARK: Output

extension GuitarToneViewModel: GuitarToneOutput {
  
  func prepareAudioTapped() async {
    let permissionGranted = await AVAudioApplication.requestRecordPermission()
    guard permissionGranted else {
      showError = true
      message = "Permission denied by user"
      status = .error("Permission denied by user")
      return
    }
    
    prepareSoundEngineGraph()
  }
}
