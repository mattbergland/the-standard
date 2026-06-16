// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TheStandard",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "StandardCore",
            targets: ["StandardCore"]
        )
    ],
    targets: [
        .target(
            name: "StandardCore"
        ),
        .testTarget(
            name: "StandardCoreTests",
            dependencies: ["StandardCore"]
        )
    ]
)
