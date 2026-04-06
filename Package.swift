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
            url: "https://github.com/irdb-holdings/irkit-releases-ksl/releases/download/26.11.0/IRKit.xcframework.zip",
            checksum: "86b4a79876d73ccc8e7ba809b0339073cbcab48d47341821d561e487e2a21884"
        )
    ]
)