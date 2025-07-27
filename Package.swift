// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IndieBuilderKit",
    platforms: [
        .iOS("17.0")
    ],
    products: [
        .library(
            name: "IndieBuilderKit",
            targets: ["IndieBuilderKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/RevenueCat/purchases-ios.git", .upToNextMajor(from: "4.30.5"))
    ],
    targets: [
        .target(
            name: "IndieBuilderKit",
            dependencies:  [
                .product(name: "RevenueCat", package: "purchases-ios"),
                .product(name: "RevenueCatUI", package: "purchases-ios")
            ],
            resources: [
                .process("Fonts")
            ]
        )
    ]
)
