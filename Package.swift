// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RestBird",
    platforms: [
        .macOS(.v10_12), .iOS(.v10),
    ],
    products: [
        .library(name: "RestBird", targets: ["RestBird"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.4.0")
    ],
    targets: [
        .target(name: "RestBird", dependencies: ["Alamofire"]),
        .testTarget(name: "RestBirdTests", dependencies: ["RestBird"])
    ]
)
