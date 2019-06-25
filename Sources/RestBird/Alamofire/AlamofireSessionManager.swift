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

    private(set) var session: Alamofire.SessionManager

    public init(config: NetworkClientConfiguration, session: Alamofire.SessionManager = .default) {
        self.config = config
        self.session = session
    }

    // MARK: - Data Task

    public func performDataTask<Request>(
        request: Request,
        completion: @escaping (Swift.Result<Data, Error>) -> Void
    ) where Request : DataRequest {
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

// MARK: - Multipart

extension AlamofireSessionManager {

    public func performUploadTask<Request>(
        request: Request,
        uploadProgress: ((Progress) -> Void)?,
        completion: @escaping (Swift.Result<Data, Error>) -> Void
    ) where Request : MultipartRequest {
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

        let apiURL = config.baseUrl + (request.suffix ?? "")

        let multipartFormData: (Alamofire.MultipartFormData) -> Void = { multipartFormData in
            if let part = request.part {
                switch part {
                case .path(let url, let name):
                    multipartFormData.append(url, withName: name)
                case .data(let data, let name, let mimeType):
                    multipartFormData.append(data, withName: name, mimeType: mimeType)
                }
            }
            try? request.afParameters(using: self.config.jsonEncoder)?.forEach { (param) in
                guard let value = String(describing: param.value).data(using: .utf8) else { return }
                multipartFormData.append(value, withName: param.key)
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

        session.upload(multipartFormData: multipartFormData, to: apiURL, encodingCompletion: encodingCompletion)
    }
}

// MARK: - DataResponse -> Result<Data>

extension Alamofire.DataResponse {

    func toResult() -> Swift.Result<Value, Error> {
        switch self.result {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            return .failure(error)
        }
    }
}
