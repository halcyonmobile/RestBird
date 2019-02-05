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

    public weak var delegate: SessionManagerDelegate?

    private(set) var sessionManager: Alamofire.SessionManager
    private let logger: NetworkLogger

    public init(sessionManager: Alamofire.SessionManager = .default, logger: NetworkLogger = NetworkConsoleLogger()) {
        self.sessionManager = sessionManager
        self.logger = logger
    }

    // MARK: - Data Task

    public func performDataTask<Request: RestBird.DataRequest>(request: Request, baseUrl: String, completion: @escaping (RestBird.Result<Data>) -> Void) {
        let dataRequest = sessionManager.request(urlWithBaseUrl(baseUrl, request: request),
                                                 method: request.method.alamofireMethod,
                                                 parameters: request.parameters,
                                                 encoding: request.method.encoding,
                                                 headers: request.headers?.mapValues { String(describing: $0) })

        


        if request.isDebugModeEnabled, let request = dataRequest.request {
            logger.log(request: request)
        }

        if let request = dataRequest.request {
            do {
                try delegate?.sessionManager(self, willPerform: request)
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        dataRequest.responseData { response in
            if let request = response.request, let response = response.response {
                do {
                    try self.delegate?.sessionManager(self, didPerform: request, response: response)
                } catch {
                    completion(.failure(error))
                    return
                }
            }
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

        if let request = uploadRequest.request {
            do {
                try delegate?.sessionManager(self, willPerform: request)
            } catch {
                completion(.failure(error))
            }
        }
        uploadRequest.responseData { response in
            if let request = response.request, let response = response.response {
                do {
                    try self.delegate?.sessionManager(self, didPerform: request, response: response)
                } catch {
                    completion(.failure(error))
                    return
                }
            }
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
