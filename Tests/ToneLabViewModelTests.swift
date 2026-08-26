import Testing
@testable import GuitarToneLab

@Test func initialAudioStateIsIdle() {
    let model = ToneLabViewModel()
    #expect(model.audioState == .idle)
}

@Test func preparingPlaybackMakesTrackReady() {
    let model = ToneLabViewModel()
    model.preparePlayback()
    #expect(model.audioState == .ready)
}

