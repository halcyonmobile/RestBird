//
//  URLSessionManager.swift
//  RestBird
//
//  Created by Botond Magyarosi on 02/10/2018.
//  Copyright © 2018 Halcyon Mobile. All rights reserved.
//

import Foundation
import RestBird

public final class URLSessionManager: SessionManager {

    private(set) var session: URLSession

    public weak var delegate: SessionManagerDelegate?

    init(session: URLSession = .shared) {
        self.session = session
    }

    public func performDataTask<Request: DataRequest>(request: Request, baseUrl: String, completion: @escaping (Result<Data>) -> Void) {
        guard let urlRequest = createRequestFor(dataRequest: request, baseUrl: baseUrl) else {
            assertionFailure("Not a valid url for request: \(request)")
            return
        }

        // Execute request
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
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

    public func performUploadTask<Request: UploadRequest>(request: Request, baseUrl: String, completion: @escaping (Result<Data>) -> Void) {
        guard var urlRequest = createRequestFor(uploadRequest: request, baseUrl: baseUrl) else {
            assertionFailure("Not a valid url for request: \(request)")
            return
        }
        let completionHandler: (Data?, URLResponse?, Error?) -> Void = { data, response, error in
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
        switch request.source {
        case .data(let data):
            uploadTask = URLSession.shared.uploadTask(with: urlRequest, from: data, completionHandler: completionHandler)
        case .url(let url):
            uploadTask = URLSession.shared.uploadTask(with: urlRequest, fromFile: url, completionHandler: completionHandler)
        case .stream(let inputStream):
            // TODO: track the progress of the upload
            urlRequest.httpBodyStream = inputStream
            uploadTask = URLSession.shared.uploadTask(withStreamedRequest: urlRequest)
        }
        uploadTask.resume()
    }
}

// MARK: - DataRequest

private extension URLSessionManager {
    func createRequestFor<Request: DataRequest>(dataRequest: Request, baseUrl: String) -> URLRequest? {
        var urlString = baseUrl
        if let suffix = dataRequest.suffix {
            urlString += suffix
        }

        if includeParamsInQuery(request: dataRequest), let query = queryString(for: dataRequest.parameters) {
            urlString += "?\(query)"
        }

        guard let url = URL(string: urlString) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = dataRequest.method.rawValue

        if let headers = dataRequest.headers?.mapValues({ String(describing: $0) }) {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

        if !includeParamsInQuery(request: dataRequest) {
            if isJSONContentType(request: urlRequest) {
                if let parameters = dataRequest.parameters {
                    urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
                }
            } else if let query = queryString(for: dataRequest.parameters) {
                urlRequest.httpBody = query.data(using: .utf8)
            }
        }

        return urlRequest
    }

    func includeParamsInQuery<A: Request>(request: A) -> Bool {
        switch request.method {
        case .get, .head, .delete: return true
        case .post, .put, .patch: return false
        }
    }

    func isJSONContentType(request: URLRequest) -> Bool {
        if let contentType = request.allHTTPHeaderFields?["Content-Type"] {
            return contentType == "application/json"
        }
        return false
    }

    func queryString(for parameters: [String: Any]?) -> String? {
        guard let parameters = parameters else { return nil }
        let query = parameters.mapValues { String(describing: $0) }.map { "\($0)=\($1)" }.joined(separator: "&")
        return query
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
