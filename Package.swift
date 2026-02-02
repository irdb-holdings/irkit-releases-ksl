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
              url: "https://github.com/irdb-holdings/irkit-releases-ksl/releases/download/26.3.1/IRKit.xcframework.zip"
              checksum: "e753f4642823700e4b1cca1ae875cc904e74299ff1f377bfc0ce4addb8e07bf2"
        )
    ]
)
