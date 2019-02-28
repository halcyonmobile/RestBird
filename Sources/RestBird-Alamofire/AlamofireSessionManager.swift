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

    public init(sessionManager: Alamofire.SessionManager = .default) {
        self.sessionManager = sessionManager
    }

    // MARK: - Data Task

    func performDataTask(
        request: URLRequest,
        completion: @escaping (RestBird.Result<Data>) -> Void
    ) {
        let dataRequest = sessionManager.request(request)

        if let request = dataRequest.request {
            do {
                try delegate?.sessionManager(self, willPerform: request)
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        dataRequest.validate().responseData { response in
            if let urlRequest = response.request, let urlResponse = response.response {
                do {
                    try self.delegate?.sessionManager(self, didPerform: urlRequest, response: urlResponse, data: response.data)
                } catch {
                    completion(.failure(error))
                    return
                }
            }
            completion(response.toResult())
        }
    }
}

// MARK: - Upload task

extension AlamofireSessionManager {

    func performUploadTask(
        request: URLRequest,
        source: UploadSource,
        completion: @escaping (RestBird.Result<Data>) -> Void
    ) {
        // We need to observe when `uploadRequest` gets set as in case of `.multipart` this will be set later, in `encodingCompletion` and we can't call these methods right after `sessionManager.upload` as `uploadRequest` will be nil at that point.
        var uploadRequest: Alamofire.UploadRequest? {
            didSet {
                // We don't need to treat the case where `uploadRequest` is nil as that would be a failure and `completion(.failure(error))` would be called in `encodingCompletion`.
                if let request = uploadRequest?.request {
                    do {
                        try delegate?.sessionManager(self, willPerform: request)
                    } catch {
                        completion(.failure(error))
                    }
                }
                uploadRequest?.validate().responseData { response in
                    if let urlRequest = response.request, let urlResponse = response.response {
                        do {
                            try self.delegate?.sessionManager(self, didPerform: urlRequest, response: urlResponse, data: response.data)
                        } catch {
                            completion(.failure(error))
                            return
                        }
                    }
                    completion(response.toResult())
                }
            }
        }

        switch source {
        case .url(let url):
            uploadRequest = sessionManager.upload(url, to: request)
        case .data(let data):
            uploadRequest = sessionManager.upload(data, to: request)
        case .stream(let stream):
            uploadRequest = sessionManager.upload(stream, to: request)
        case .multipart(let name, let fileName, let mimeType):
            let multipartFormData: (Alamofire.MultipartFormData) -> Void = { multipartFormData in
                for (key, value) in request.parameters ?? [:] {
                    if let value = value as? String, let valueData = value.data(using: .utf8) {
                        multipartFormData.append(valueData, withName: key)
                    }

                    if let data = value as? Data {
                        multipartFormData.append(data, withName: name, fileName: fileName, mimeType: mimeType)
                    }
                }
            }

            let encodingCompletion: ((Alamofire.SessionManager.MultipartFormDataEncodingResult) -> Void) = { result in
                switch result {
                case .success(let request, _, _):
                    uploadRequest = request
                case .failure(let error):
                    completion(.failure(error))
                }
            }

            sessionManager.upload(multipartFormData: multipartFormData, to: request)
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

// MARK: - RestBird.ParameterEncoding -> Alamofire.ParameterEncoding

fileprivate extension RestBird.ParameterEncoding {
    var alamofireParameterEncoding: Alamofire.ParameterEncoding {
        switch self {
        case .url:
            return URLEncoding.default
        case .json:
            return JSONEncoding.default
        }
    }
}
