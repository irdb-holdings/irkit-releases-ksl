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
            url: "https://github.com/irdb-holdings/irkit-releases-ksl/releases/download/26.6.0/IRKit.xcframework.zip",
            checksum: "40a257e16b0f2964b05dbc43bbe85cd20f670057a7bbf9c70508e0d71e010196"
        ),
        .binaryTarget(
            name: "OnnxRuntime",
            url: "https://github.com/irdb-holdings/irkit-releases-ksl/releases/download/26.6.0/onnxruntime.xcframework.zip",
            checksum: "4e7a24692e7fb315229ff0446d4c64dbfa69f33f4cd8612473643f79cf7913d2"
        )
    ]
)
