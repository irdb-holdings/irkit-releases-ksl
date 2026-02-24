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
            url: "https://github.com/irdb-holdings/irkit-releases-ksl/releases/download/26.8.0/IRKit.xcframework.zip",
            checksum: "282c63fab9867a540a8277ca8be3276429c5f9a68c76e919b95516c90b94b491"
        ),
        .binaryTarget(
            name: "OnnxRuntime",
            url: "https://github.com/irdb-holdings/irkit-releases-ksl/releases/download/26.8.0/onnxruntime.xcframework.zip",
            checksum: "d0cbcb19e1a1d6f051bf5ad7db6da0d8b8e71b6def3760d0b1bbb76ccb08d4dc"
        )
    ]
)
