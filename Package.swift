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
            url: "https://github.com/irdb-holdings/irkit-releases-ksl/releases/download/26.7.2/IRKit.xcframework.zip",
            checksum: "c83159d07f2ab3f6bbeee3ea2f9de46193c33769938ae608b714d5e9cb9afa0f"
        ),
        .binaryTarget(
            name: "OnnxRuntime",
            url: "https://github.com/irdb-holdings/irkit-releases-ksl/releases/download/26.7.2/onnxruntime.xcframework.zip",
            checksum: "e0812c6fb7ce2d1fd92c82e7f6a2aa0b5e090ffdd6ecd68e87ab684ea2c8eb36"
        )
    ]
)
