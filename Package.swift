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
              url: "https://github.com/irdb-holdings/irkit-releases-ksl/releases/download/26.4.1/IRKit.xcframework.zip",
              checksum: "7ee2e2ddf130d5fd5665da5da33ff3724d37b000f25520c0527103296037a966"
        )
    ]
) 
