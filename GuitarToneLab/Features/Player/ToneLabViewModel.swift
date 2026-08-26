import Observation

@Observable
final class ToneLabViewModel {
    private(set) var audioState: AudioPlaybackState = .idle

    func preparePlayback() {
        audioState = .ready
    }
}

