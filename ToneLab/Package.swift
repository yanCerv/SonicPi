// swift-tools-version: 6.2
import PackageDescription

let package = Package(
  name: "GuitarToneLab",
  platforms: [.iOS(.v18), .macOS(.v15), .visionOS(.v26)],
  products: [
    .library(name: "GuitarToneLab", targets: ["GuitarToneLab"])
  ],
  targets: [
    .target(name: "GuitarToneLab", path: "GuitarToneLab"),
    .testTarget(name: "GuitarToneLabTests",dependencies: ["GuitarToneLab"], path: "Tests")
  ]
)

