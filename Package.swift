// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Exy",
    products: [
        .executable(name: "exy", targets: ["exy"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "exy",
            dependencies: ["ExyLib"]
        ),
        .target(
            name: "ExyLib",
            dependencies: []
        ),
        .testTarget(
            name: "ExyTests",
            dependencies: ["ExyLib"]
        ),
    ]
)
