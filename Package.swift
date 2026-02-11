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
            url: "https://github.com/irdb-holdings/irkit-releases-ksl/releases/download/26.6.1/IRKit.xcframework.zip",
            checksum: "7e5b3c49f24a10765dac7ce2e5458a8076c5604ed19053cd08fc27f308e8fffb"
        ),
        .binaryTarget(
            name: "OnnxRuntime",
            url: "https://github.com/irdb-holdings/irkit-releases-ksl/releases/download/26.6.1/onnxruntime.xcframework.zip",
            checksum: "948d157c378fa9c2ff5fcd974c9dffd8582346739bd3ee85c394eee1653c9c5b"
        )
    ]
)
