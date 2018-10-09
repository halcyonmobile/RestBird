# RestBird 🦉

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/681dfe685db146c182483b44bd962a06)](https://app.codacy.com/app/Halcyon-Mobile/RestBird?utm_source=github.com&utm_medium=referral&utm_content=halcyonmobile/RestBird&utm_campaign=Badge_Grade_Dashboard)
[![Build Status](https://travis-ci.org/halcyonmobile/RestBird.svg?branch=master)](https://travis-ci.org/halcyonmobile/RestBird)

Lightweight, stateless REST network manager over the Codable protocol.

- [About](#about)
- [Requirements](#requirements)
- [Features](#features)
- [Installation Instructions](#installation-instructions)
    - [Swift Package Manager](#swift-package-manager)
    - [CocoaPods](#cocoapods)
    - [Carthage](#carthage)
- [Usage](#usage)
- [License](#license)

## About

## Requirements

- iOS 9.0+ / macOS 10.11+
- XCode 10.0+
- Swift 4.2+

## Features

- [x] Codable support.

## Installation Instructions

### Swift Package Manager

Add RestBird as a dependency to your project.

```swift
.Package(url: "https://github.com/halcyonmobile/RestBird.git", majorVersion: 1)
```

You can use RestBird and implement your own session handling or use one of the built-in drivers implemented by RestBird (Alamofire and URLSession).

```swift
// Use RestBird without any driver
targets: [
    Target(name: "YourTarget", dependencies: ["RestBird"])
]

// Use the URLSession Driver
targets: [
    Target(name: "YourTarget", dependencies: [
        .product(name: "RestBird-URLSession", package: "RestBird")
    ])
]

// Use the Alamofire Driver
targets: [
    Target(name: "YourTarget", dependencies: [
        .product(name: "RestBird-Alamofire", package: "RestBird")
    ])
]
```

### CocoaPods

```ruby
pod 'RestBird'
```

### Carthage

```swift
github "halcyonmobile/RestBird"
```

## Usage

## License

RestBird is released under the MIT license. [See LICENSE](https://github.com/halcyonmobile/RestBird/blob/master/LICENSE) for details.
