// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RestBird",
    products: [
        .library(name: "RestBird", targets: ["RestBird"]),
        .library(name: "RestBird-Alamofire", targets: ["RestBird-Alamofire"]),
        .library(name: "RestBird-URLSession", targets: ["RestBird-URLSession"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.0.0")
    ],
    targets: [
        .target(name: "RestBird", dependencies: []),
        .target(name: "RestBird-Alamofire", dependencies: ["RestBird", "Alamofire"]),
        .target(name: "RestBird-URLSession", dependencies: ["RestBird"]),
        .testTarget(name: "RestBirdTests", dependencies: ["RestBird"]),
    ]
)
