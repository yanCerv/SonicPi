// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "GuitarToneLab",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        .executable(name: "GuitarToneLab", targets: ["GuitarToneLab"])
    ],
    targets: [
        .executableTarget(
            name: "GuitarToneLab",
            path: "GuitarToneLab",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "GuitarToneLabTests",
            dependencies: ["GuitarToneLab"],
            path: "Tests"
        )
    ]
)

