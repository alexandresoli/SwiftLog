// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SwiftLog",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftLog",
            targets: ["SwiftLog"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "SwiftLog",
            path: "./SwiftLog.xcframework"
        )
    ]
)
