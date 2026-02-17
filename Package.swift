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
            targets: ["IRKitCore", "OnnxRuntime"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "IRKitCore",
            url: "https://github.com/irdb-holdings/irkit-releases-ksl/releases/download/26.7.1/IRKit.xcframework.zip",
            checksum: "badbc842a976b89ec49bc91eaccc2d4ec607c654c138cf313d53a97bd5533794"
        ),
        .binaryTarget(
            name: "OnnxRuntime",
            url: "https://github.com/irdb-holdings/irkit-releases-ksl/releases/download/26.7.1/onnxruntime.xcframework.zip",
            checksum: "333fe9a27a62c9f1a4efcce5257c1cf83eea7b73ac147d9fb23fec27c143f5b8"
        )
    ]
)
