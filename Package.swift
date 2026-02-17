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
            url: "https://github.com/irdb-holdings/irkit-releases-ksl/releases/download/26.7.0/IRKit.xcframework.zip",
            checksum: "9a82a384ce23cc821103125fc0e76cb745ffc23e159a282b41baca991a9a27c0"
        ),
        .binaryTarget(
            name: "OnnxRuntime",
            url: "https://github.com/irdb-holdings/irkit-releases-ksl/releases/download/26.7.0/onnxruntime.xcframework.zip",
            checksum: "3d0d1e9bc5e49ed39b14a5d9bc63c85e015d0983bc51205d534be1174a3c320b"
        )
    ]
)
