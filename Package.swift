// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "IRKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "IRKit",
            targets: ["IRKitCore"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "IRKitCore",
            url: "https://github.com/irdb-holdings/irkit-releases-ksl/releases/download/26.11.0/IRKit.xcframework.zip",
            checksum: "9ad64946996b837199aa5f0b3d7daae200d5507933fa3c4526ed0d57716d9cee"
        )
    ]
)
