//
//  AlamofireSessionManager.swift
//  RestBird
//
//  Created by Botond Magyarosi on 02/10/2018.
//  Copyright © 2018 Halcyon Mobile. All rights reserved.
//

import Foundation
import Alamofire

public final class AlamofireSessionManager: RestBird.SessionManager {

    public var config: NetworkClientConfiguration

    public weak var delegate: SessionManagerDelegate?

    private(set) var session: Alamofire.Session

    public init(config: NetworkClientConfiguration, session: Alamofire.Session = .default) {
        self.config = config
        self.session = session
    }

    // MARK: - Data Task

    public func performDataTask<Request, T>(
        request: Request,
        completion: @escaping (Result<T, Error>) -> Void
    ) where Request : DataRequest, T : Decodable {
        let url = config.baseUrl + (request.suffix ?? "")

        let parameters: Alamofire.Parameters?
        do {
            parameters = try request.afParameters(using: config.jsonEncoder)
        } catch {
            completion(.failure(error))
            return
        }

        let dataRequest = session.request(url,
                                          method: request.afMethod,
                                          parameters: parameters,
                                          encoding: request.afEncoding,
                                          headers: request.afHeaders)

        if let request = dataRequest.request {
            do {
                try delegate?.sessionManager(self, willPerform: request)
            } catch {
                completion(.failure(error))
                return
            }
        }

        dataRequest.validate().responseDecodable(of: T.self, decoder: config.jsonDecoder) { response in
            if let urlRequest = response.request, let urlResponse = response.response {
                do {
                    try self.delegate?.sessionManager(self, didPerform: urlRequest, response: urlResponse, data: response.data)
                } catch {
                    completion(.failure(error))
                    return
                }
            }

            completion(response.result.mapError{ $0 })
        }
    }
}

// MARK: - Multipart

extension AlamofireSessionManager {

    public func performUploadTask<Request>(
        request: Request,
        uploadProgress: ((Progress) -> Void)?,
        completion: @escaping (Swift.Result<Data, Error>) -> Void
    ) where Request : MultipartRequest {

    }

    public func performUploadTask<Request, T>(
        request: Request,
        uploadProgress: ((Progress) -> Void)?,
        completion: @escaping (Swift.Result<T, Error>) -> Void
    ) where Request : MultipartRequest, T : Decodable {
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

                uploadRequest?.uploadProgress { uploadProgress?($0) }

                uploadRequest?.validate()
                    .responseDecodable(of: T.self, decoder: config.jsonDecoder, completionHandler: { response in
                        if let urlRequest = response.request, let urlResponse = response.response {
                            do {
                                try self.delegate?.sessionManager(self, didPerform: urlRequest, response: urlResponse, data: response.data)
                            } catch {
                                completion(.failure(error))
                                return
                            }
                        }
                        completion(response.result.mapError{ $0 })
                    })
            }
        }

        let apiURL = config.baseUrl + (request.suffix ?? "")

        let multipartFormData: (Alamofire.MultipartFormData) -> Void = { multipartFormData in
            for part in request.parts {
                switch part {
                case .path(let url, let name):
                    multipartFormData.append(url, withName: name)
                case .data(let data, let name, let fileName, let mimeType):
                    if let fileName = fileName {
                        multipartFormData.append(data, withName: name, fileName: fileName, mimeType: mimeType)
                    } else {
                        multipartFormData.append(data, withName: name, mimeType: mimeType)
                    }
                }
            }
            try? request.afParameters(using: self.config.jsonEncoder)?.forEach { (param) in
                if let value = param.value as? String {
                    if let data = value.data(using: .utf8) {
                        multipartFormData.append(data, withName: param.key)
                    }
                } else {
                    if let data = try? JSONSerialization.data(withJSONObject: param.value, options: .fragmentsAllowed) {
                        multipartFormData.append(data, withName: param.key)
                    }
                }
            }
        }

        guard let url = try? apiURL.asURL() else { return }

        session.upload(multipartFormData: multipartFormData, to: url, method: request.afMethod, headers: request.afHeaders)
            .validate()
            .responseDecodable(of: T.self, decoder: config.jsonDecoder) { response in
                completion(response.result.mapError{ $0 })
        }
    }
}
