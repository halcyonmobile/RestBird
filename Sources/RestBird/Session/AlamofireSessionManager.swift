//
//  AlamofireSessionManager.swift
//  RestBird
//
//  Created by Botond Magyarosi on 02/10/2018.
//  Copyright © 2018 Halcyon Mobile. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireSessionManager: SessionManager {

    private(set) var sessionManager: Alamofire.SessionManager

    init(sessionManager: Alamofire.SessionManager = .default) {
        self.sessionManager = sessionManager
    }

    // MARK: - Data Task

    func performDataTask<Request: DataRequest>(request: Request, completion: @escaping (Result<Data>) -> Void) {
        let dataRequest = sessionManager.request("hello",
                                                 method: .post,
                                                 parameters: request.parameters,
                                                 encoding: request.method.encoding,
                                                 headers: nil)

        dataRequest.responseData { response in
            completion(response.toResult())
        }
    }

    func performUploadTask<Request: UploadRequest>(request: Request, completion: @escaping (Result<Data>) -> Void) {
        let uploadRequest: Alamofire.UploadRequest
        switch request.source {
        case .url(let url):
            uploadRequest = sessionManager.upload(url,
                                                  to: "hello",
                                                  method: request.method.alamofireMethod,
                                                  headers: nil)
        case .data(let data):
            uploadRequest = sessionManager.upload(data,
                                                  to: "hello",
                                                  method: request.method.alamofireMethod,
                                                  headers: nil)
        case .stream(let stream):
            uploadRequest = sessionManager.upload(stream,
                                                  to: "hello",
                                                  method: request.method.alamofireMethod,
                                                  headers: nil)
        }

        uploadRequest.responseData { response in
            completion(response.toResult())
        }
    }
}

extension Alamofire.DataResponse {

    func toResult() -> Result<Value> {
        switch self.result {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            return .failure(error)
        }
    }
}

fileprivate extension HTTPMethod {

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
