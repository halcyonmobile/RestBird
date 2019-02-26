# RestBird 🦉

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/681dfe685db146c182483b44bd962a06)](https://app.codacy.com/app/Halcyon-Mobile/RestBird?utm_source=github.com&utm_medium=referral&utm_content=halcyonmobile/RestBird&utm_campaign=Badge_Grade_Dashboard)
[![Build Status](https://travis-ci.org/halcyonmobile/RestBird.svg?branch=master)](https://travis-ci.org/halcyonmobile/RestBird)
[![codecov](https://codecov.io/gh/halcyonmobile/RestBird/branch/master/graph/badge.svg)](https://codecov.io/gh/halcyonmobile/RestBird)

- [About](#about)
- [Requirements](#requirements)
- [Features](#features)
- [Driver Coverage](#driver-coverage)
- [Installation Instructions](#installation-instructions)
    - [Swift Package Manager](#swift-package-manager)
    - [CocoaPods](#cocoapods)
    - [Carthage](#carthage)
- [Setup](#setup)
- [Usage](#usage)
- [Meta Support](#meta-support)
- [Convenience](#convenience)
- [License](#license)

## About

Lightweight, stateless REST network manager over the Codable protocol.

To learn more aboit this library, check out the [documentation](https://halcyonmobile.github.io/RestBird/).

## Requirements

- iOS 9.0+ / macOS 10.11+
- XCode 10.0+
- Swift 4.2+

## Features

- [x] Codable support.
- [x] Built-in Alamofire driver.
- [x] Built-in URLSession driver.
- [x] PromiseKit wrapper.
- [ ] Automatic request parameter serialization (Codable?)

## Driver coverage

The following table describes how much the specific drivers cover `SessionManager` defined in the Core of RestBird.

|                         | Coverage |
|-------------------------|----------|
| AlamofireSessionManager | 100%     |
| URLSessionManager       | 70%      |

## Installation Instructions

### Swift Package Manager

Add RestBird as a dependency to your project.

```swift
.Package(url: "https://github.com/halcyonmobile/RestBird.git", majorVersion: 0, minorVersion: 4)
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
# use RestBird without any driver
pod 'RestBird'

# use RestBird with Alamofire driver
pod 'RestBird/Alamofire'

# use RestBird with URLSession driver
pod 'RestBird/URLSession'
```

You can also try it out by running

```bash
pod try RestBird
```

### Carthage

```swift
github "halcyonmobile/RestBird"
```

## Setup

Steps for setting up the project for development:
- Clone the repo
- Generate Xcode project by executing `swift package generate-xcodeproj`
- Open project

## Usage

### General

First you need to create your `NetworkClientConfiguration` configuration with your custom or one of the provided session manager drivers. We're going to use the AlamofireSessionManager.

```swift
struct MainAPIConfiguration: NetworkClientConfiguration {
    let baseUrl = "https://api.example.com"
    let sessionManager = AlamofireSessionManager()
}
```

Now we can pass this configuration to the network client.

```swift
let networkClient = NetworkClient(configuration: MainAPIConfiguration())
```

In order to make requests, a `DataRequest` object should be defined.

```swift
struct SignIn: DataRequest {
    typealias ResponseType = Authentication

    let email: String
    let password: String

    let suffix: String? = API.Path.login
    let method: HTTPMethod = .post
    var parameters: [String : Any]? {
        return [API.Param.email: email, API.Param.password: password]
    }
}
```

Now use your network client to execute requests.

```swift
let request = SignIn(email: "john-doe@acme.inc", password: "123456")
networkClient.execute(request: request, completion: { result: Result<Authentication> in
    print(result)
})
```

### Middlewares

Middlewares are a powerful way to intercept network requests or react to the response the endpoint returns.

At the moment, middlewares fall under two categories:

- Pre Middlewares (evaluated before the request is about to be executed)
- Post Middlewares (evaluated after the request was executed)

```Swift
struct LoggerMiddleware: PreMiddleware {
    func willPerform(_ request: URLRequest) throws {
        Logger.log(resquest)
    }
}

struct ErrorMiddleware: PostMiddleware {
    func didPerform(_ request: URLRequest, response: URLResponse, data: Data?) throws {
        if let data = data, let error = ErrorProvider.provide(for: data) {
            throw error
        }
    }
}

// Register middleware
networkClient.register(LoggerMiddleware())
networkClient.register(ErrorMiddleware())
```

## Meta support

To avoid writing boilerplate code for network classes, we wrote a couple of templates to generate code using [Sourcery](https://github.com/krzysztofzablocki/Sourcery). Head over to the [template repository](https://github.com/halcyonmobile/RestBird-Sourcery).

Here's how two requests would look like using the templates:

```Swift
/// sourcery: Service
protocol PostService {

    /// sourcery: path = /posts/\(id)
    /// sourcery: pathParam = id
    func get(id: String, completion: (result: Result<Post>) -> Void)

    /// sourcery: method = post, path = /posts
    /// sourcery: parameter = post
    /// sourcery: parameter = json
    func save(post: Post, completion: (result: Result<Post>) -> Void)
}
```

## Convenience

You can find convenience wrappers for RestBird which are not distributed through the package. This includes a PromiseKit and an RxSwift wrapper.

Check out [here](https://github.com/halcyonmobile/RestBird/tree/master/Convenience).

## License

RestBird is released under the MIT license. [See LICENSE](https://github.com/halcyonmobile/RestBird/blob/master/LICENSE) for details.
