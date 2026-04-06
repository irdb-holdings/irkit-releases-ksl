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
            url: "https://github.com/irdb-holdings/irkit-releases-ksl/releases/download/26.11.2/IRKit.xcframework.zip",
            checksum: "fdb5f78be2dafc7e03c6efc8f56705dca3b1ebb993452e0988337d0bed18611f"
        )
    ]
)