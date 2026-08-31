//
//  GuitarTonePlaybackStatus.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 26/08/26.
//

enum GuitarTonePlaybackStatus: Equatable {
  case idle
  case ready
  case finished
  case error(String)

  var title: String {
    switch self {
    case .idle: "Listo para configurar audio"
    case .ready: "Cadena de audio preparada"
    case .finished: "Finalizar reproducción"
    case let .error(message): "Error: \(message)"
    }
  }

  var symbolName: String {
    switch self {
    case .idle: "waveform"
    case .ready: "checkmark.circle.fill"
    case .finished: "checkmark.circle.fill"
    case .error: "exclamationmark.triangle.fill"
    }
  }
}

