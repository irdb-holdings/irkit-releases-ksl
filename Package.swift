// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "IRKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "IRKit", targets: ["IRKit"])
    ],
    targets: [
        .binaryTarget(
            name: "IRKit",
            url: "https://github.com/irdb-holdings/irkit-releases-ksl/releases/download/26.1.0/IRKit.xcframework.zip",
            checksum: "63e0d798f69d2f22ca1edb42a0647178f00ca5a66d35339171310c289c4b991c"
        )
    ]
)
