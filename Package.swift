// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DateTimeExtractor",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DateTimeExtractor",
            targets: ["DateTimeExtractor"]
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DateTimeExtractor",
            path: "Sources"
        ),
        .testTarget(
            name: "DateTimeExtractorTests",
            dependencies: ["DateTimeExtractor"]
        )
    ]
)
