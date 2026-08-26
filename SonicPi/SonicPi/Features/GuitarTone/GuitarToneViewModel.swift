//
//  GuitarToneViewModel.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 26/08/26.
//

import Foundation
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
  
}

//MARK: Output

extension GuitarToneViewModel: GuitarToneOutput {
  
  func prepareAudioTapped() {
    do {
      try audioEngine.prepareGraph()
      status = .ready
    } catch {
      showError = true
      message = error.localizedDescription
      status = .error(error.localizedDescription)
    }
  }
}
