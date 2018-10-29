//
//  AlamofireSessionManager.swift
//  RestBird
//
//  Created by Botond Magyarosi on 02/10/2018.
//  Copyright © 2018 Halcyon Mobile. All rights reserved.
//

import Foundation
#if !COCOAPODS
import RestBird
#endif
import Alamofire

public final class AlamofireSessionManager: RestBird.SessionManager {

    private(set) var sessionManager: Alamofire.SessionManager

    public init(sessionManager: Alamofire.SessionManager = .default) {
        self.sessionManager = sessionManager
    }

    // MARK: - Data Task

    public func performDataTask<Request: RestBird.DataRequest>(request: Request, baseUrl: String, completion: @escaping (RestBird.Result<Data>) -> Void) {
        let method = request.method
        let url = urlWithBaseUrl(baseUrl, request: request)
        let headers = request.headers?.mapValues { String(describing: $0) }
        let parameters = request.parameters
        if request.isDebugModeEnabled {
            print("[NETWORK]: Request url: \(method) \(url)")
            print("[NETWORK]: Request headers: \(headers ?? [:])")
            print("[NETWORK]: Request parameters: \(parameters ?? [:])")
        }
        let dataRequest = sessionManager.request(url,
                                                 method: method.alamofireMethod,
                                                 parameters: parameters,
                                                 encoding: request.method.encoding,
                                                 headers: headers)

        dataRequest.responseData { response in
            completion(response.toResult())
        }
    }

    // MARK: - Private

    // TODO: Improve the way URL strings are built.
    // Take a look at https://github.com/SwifterSwift/SwifterSwift/blob/master/Sources/Extensions/Foundation/URLExtensions.swift
    private func urlWithBaseUrl<Request: RestBird.Request>(_ baseUrl: String, request: Request) -> String {
        if let suffix = request.suffix {
            return baseUrl + suffix
        }
        return baseUrl
    }
}

// MARK: - Upload task

extension AlamofireSessionManager {

    public func performUploadTask<Request: RestBird.UploadRequest>(request: Request, baseUrl: String, completion: @escaping (RestBird.Result<Data>) -> Void) {
        let uploadRequest: Alamofire.UploadRequest
        switch request.source {
        case .url(let url):
            uploadRequest = sessionManager.upload(url,
                                                  to: urlWithBaseUrl(baseUrl, request: request),
                                                  method: request.method.alamofireMethod,
                                                  headers: request.headers?.mapValues { String(describing: $0) })
        case .data(let data):
            uploadRequest = sessionManager.upload(data,
                                                  to: urlWithBaseUrl(baseUrl, request: request),
                                                  method: request.method.alamofireMethod,
                                                  headers: request.headers?.mapValues { String(describing: $0) })
        case .stream(let stream):
            uploadRequest = sessionManager.upload(stream,
                                                  to: urlWithBaseUrl(baseUrl, request: request),
                                                  method: request.method.alamofireMethod,
                                                  headers: request.headers?.mapValues { String(describing: $0) })
        }

        uploadRequest.responseData { response in
            completion(response.toResult())
        }
    }
}

// MARK: - DataResponse -> Result<Data>

extension Alamofire.DataResponse {

    func toResult() -> RestBird.Result<Value> {
        switch self.result {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            return .failure(error)
        }
    }
}

// MARK: - RestBird.HTTPMethod -> Alamofire.HTTPMethod

fileprivate extension RestBird.HTTPMethod {

    var alamofireMethod: Alamofire.HTTPMethod {
        switch self {
        case .get: return .get
        case .head: return .head
        case .post: return .post
        case .put: return .put
        case .delete: return .delete
        case .patch: return .patch
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .get,
             .head:
            return URLEncoding.default
        case .post,
             .put,
             .delete,
             .patch:
            return JSONEncoding.default
        }
    }
}
