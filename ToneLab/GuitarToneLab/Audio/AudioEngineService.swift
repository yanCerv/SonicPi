import AVFAudio

/// The future owner of the `AVAudioEngine` graph.
///
/// Phase 1 will attach an `AVAudioPlayerNode` and an `AVAudioMixerNode` here,
/// keeping AVFAudio implementation details out of SwiftUI views.
final class AudioEngineService {
    let engine = AVAudioEngine()
}

