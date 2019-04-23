// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RestBird",
    platforms: [
        .macOS(.v10_12), .iOS(.v11),
    ],
    products: [
        .library(name: "RestBird", targets: ["RestBird"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.0.0")
    ],
    targets: [
        .target(name: "RestBird", dependencies: []),
        .testTarget(name: "RestBirdTests", dependencies: ["RestBird"])
    ]
)
