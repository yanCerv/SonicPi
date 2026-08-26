enum AudioPlaybackState: Equatable {
    case idle
    case ready
    case playing
    case paused
    case failed(String)

    var title: String {
        switch self {
        case .idle: "Listo para empezar"
        case .ready: "Pista preparada"
        case .playing: "Reproduciendo"
        case .paused: "En pausa"
        case let .failed(message): "Error: \(message)"
        }
    }

    var symbolName: String {
        switch self {
        case .idle, .ready: "waveform"
        case .playing: "play.circle.fill"
        case .paused: "pause.circle.fill"
        case .failed: "exclamationmark.triangle.fill"
        }
    }
}

