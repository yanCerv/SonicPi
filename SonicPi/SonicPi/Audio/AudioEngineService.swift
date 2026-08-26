import AVFAudio

/// Owns the AVAudioEngine graph and keeps AVFAudio out of SwiftUI views.
///
/// The first graph is deliberately small. Phase 1 will schedule a local file
/// on `player`; Phase 2 will insert effect nodes after `mixer`.
final class AudioEngineService {
  private let engine = AVAudioEngine()
  private let player = AVAudioPlayerNode()
  private let mixer = AVAudioMixerNode()
  private var graphIsPrepared = false

  func prepareGraph() throws {
    guard !graphIsPrepared else { return }

    engine.attach(player)
    engine.attach(mixer)
    engine.connect(player, to: mixer, format: nil)
    engine.connect(mixer, to: engine.mainMixerNode, format: nil)
    engine.prepare()

    graphIsPrepared = true
  }
}
