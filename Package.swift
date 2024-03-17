// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JsonRpcClient",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "JsonRpcClient",
            targets: ["JsonRpcClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/star-s/HttpClient.git", from: "0.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "JsonRpcClient",
            dependencies: ["HttpClient"]),
        .testTarget(
            name: "JsonRpcClientTests",
            dependencies: ["JsonRpcClient", "HttpClient"]),
    ]
)
