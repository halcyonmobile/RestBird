// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RestBird",
    products: [
        .library(
            name: "RestBird",
            targets: ["RestBird"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "RestBird",
            dependencies: ["Alamofire"]),
        .testTarget(
            name: "RestBirdTests",
            dependencies: ["RestBird"]),
    ]
)
