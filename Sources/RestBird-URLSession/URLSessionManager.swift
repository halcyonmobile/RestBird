//
//  URLSessionManager.swift
//  RestBird
//
//  Created by Botond Magyarosi on 02/10/2018.
//  Copyright © 2018 Halcyon Mobile. All rights reserved.
//

import Foundation
#if !COCOAPODS
import RestBird
#endif

public final class URLSessionManager: SessionManager {

    private(set) var session: URLSession

    public weak var delegate: SessionManagerDelegate?

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func performDataTask(request: URLRequest, completion: @escaping (Result<Data>) -> Void) {
        do {
            try delegate?.sessionManager(self, willPerform: request)
        } catch {
            completion(.failure(error))
            return
        }

        // Execute request
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                do {
                    try self.delegate?.sessionManager(self, didPerform: request, response: response, data: data)
                } catch {
                    completion(.failure(error))
                    return
                }
            }
            if let error = error {
                completion(.failure(error))
            } else {
                if let data = data {
                    completion(.success(data))
                } else {
                    completion(.success(Data())) // TODO: handle custom error
                }
            }
        }
        dataTask.resume()
    }

    func performUploadTask(
        request: URLRequest,
        source: UploadSource,
        completion: @escaping (RestBird.Result<Data>) -> Void
    ) {
        do {
            try delegate?.sessionManager(self, willPerform: request)
        } catch {
            completion(.failure(error))
            return
        }

        let completionHandler: (Data?, URLResponse?, Error?) -> Void = { data, response, error in
            if let response = response {
                do {
                    try self.delegate?.sessionManager(self, didPerform: request, response: response, data: data)
                } catch {
                    completion(.failure(error))
                    return
                }
            }
            if let error = error {
                completion(.failure(error))
            } else {
                if let data = data {
                    completion(.success(data))
                } else {
                    completion(.success(Data())) // TODO: handle custom error
                }
            }
        }

        let uploadTask: URLSessionUploadTask
        switch source {
        case .data(let data):
            uploadTask = URLSession.shared.uploadTask(with: urlRequest, from: data, completionHandler: completionHandler)
        case .url(let url):
            uploadTask = URLSession.shared.uploadTask(with: urlRequest, fromFile: url, completionHandler: completionHandler)
        case .stream(let inputStream):
            // TODO: track the progress of the upload
            urlRequest.httpBodyStream = inputStream
            uploadTask = URLSession.shared.uploadTask(withStreamedRequest: urlRequest)
        case .multipart(let name, let fileName, let mimeType):
            fatalError("Not implemented")
        }
        uploadTask.resume()
    }
}

// MARK: - UploadRequest

private extension URLSessionManager {

    func createRequestFor<Request: UploadRequest>(uploadRequest: Request, baseUrl: String) -> URLRequest? {
        var urlString = baseUrl
        if let suffix = uploadRequest.suffix {
            urlString += suffix
        }

        guard let url = URL(string: urlString) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = uploadRequest.method.rawValue

        if let headers = uploadRequest.headers?.mapValues({ String(describing: $0) }) {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

        return urlRequest
    }
}
