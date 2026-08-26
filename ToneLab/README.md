# Guitar Tone Lab

Guitar Tone Lab is a personal iPadOS/iOS learning project for understanding Apple's audio frameworks. It is a small SwiftUI app that will play a backing track through an `AVAudioEngine` effects chain and provide guitarist-oriented tone presets.

The goal is learning the building blocks behind music apps—not recreating GarageBand or Logic Pro.

## Current status

Phase 0 is in progress. The app has a SwiftUI shell, an explicit playback state, a test target, CI, and the folder boundaries for upcoming audio work. Audio playback, effects, and bundled audio arrive in Phase 1 and Phase 2.

## Run locally

1. Use Xcode 26.6 or newer on macOS.
2. Open `Package.swift` in Xcode.
3. Select the `GuitarToneLab` executable and run it, or run `swift test` from Terminal.

The package currently supports macOS for the development shell and declares iOS 18 as the eventual device target. Before the first iPad build, create an iOS App target in Xcode that uses the `GuitarToneLab` sources, or migrate the package sources into that target.

## Planned signal path

```text
AVAudioPlayerNode → AVAudioMixerNode → effect nodes → output node
```

Apple's [AVAudioEngine documentation](https://developer.apple.com/documentation/avfaudio/avaudioengine) describes the node graph, and [`AVAudioPlayerNode`](https://developer.apple.com/documentation/avfaudio/avaudioplayernode) is the planned source node for scheduled local-file playback.

## Scope guard

- This contains only personal, independently created code and licensed/self-created assets.
- No employer code, internal documentation, product behavior, or assets may be copied here.
- Version 1 has no accounts, cloud, recording studio, custom amp model, or AI feature.

## Project layout

```text
GuitarToneLab/
├── App/             # SwiftUI app entry and root view
├── Audio/           # AVAudioEngine graph ownership
├── Features/        # Player, tone controls, and presets UI/state
├── Models/          # Value types and playback state
├── Resources/       # Licensed or self-created audio assets
└── Services/        # Persistence and platform services
Tests/               # Fast behavior tests
```

## Next milestone

Build `player → mixer → output` with `AVAudioEngine`, then schedule one appropriately licensed backing track through an `AVAudioPlayerNode`.

