//
//  DataRequestTests.swift
//  RestBirdTests
//
//  Created by Botond Magyarosi on 04/04/2019.
//

import XCTest
import RestBird_URLSession
@testable import RestBird

final class DataRequestTests: XCTestCase {

    var config: NetworkClientConfiguration!

    override func setUp() {
        struct Config: NetworkClientConfiguration {
            let baseUrl: String = "http://localhost/v1/"
            let jsonDecoder: JSONDecoder = JSONDecoder()
            let jsonEncoder: JSONEncoder = JSONEncoder()
            let sessionManager: SessionManager = URLSessionManager()
        }
        config = Config()
    }


    func testGET_woParams_woHeaders() {
        struct TestRequest: DataRequest {
            var parameters: EmptyRequest?

            typealias ResponseType = EmptyResponse
            typealias RequestType = EmptyRequest

            var suffix: String? = "bar"
        }

        let request = TestRequest()
        let urlRequest = try! request.toUrlRequest(using: config)

        XCTAssertEqual(urlRequest.url?.absoluteString, "http://localhost/v1/bar")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, nil)
    }

    func testGET_woParams_wHeaders() {
        struct TestRequest: DataRequest {
            var parameters: EmptyRequest?

            typealias ResponseType = EmptyResponse
            typealias RequestType = EmptyRequest

            var suffix: String? = "bar"
            var headers: RequestHeaders? = [
                "str": "test",
                "num": 10
            ]
        }

        let request = TestRequest()
        let urlRequest = try! request.toUrlRequest(using: config)

        XCTAssertEqual(urlRequest.url?.absoluteString, "http://localhost/v1/bar")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, ["str": "test", "num": "10"])
    }

    static var allTests = [
        ("testGET_woParams_woHeaders", testGET_woParams_woHeaders),
        ("testGET_woParams_wHeaders", testGET_woParams_wHeaders),
    ]
}
