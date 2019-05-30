// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Exy",
    products: [
        .executable(name: "exy", targets: ["exy"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tuist/xcodeproj", from: "6.7.0"),
    ],
    targets: [
        .target(
            name: "exy",
            dependencies: ["ExyLib"]
        ),
        .target(
            name: "ExyLib",
            dependencies: ["xcodeproj"]
        ),
        .testTarget(
            name: "ExyTests",
            dependencies: ["ExyLib"]
        ),
    ]
)
