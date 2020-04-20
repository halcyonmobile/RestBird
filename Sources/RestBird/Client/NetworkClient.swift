//
//  NetworkClient.swift
//  NetworkClient
//
//  Created by Botond Magyarosi on 01/10/2018.
//  Copyright © 2018 Halcyon Mobile. All rights reserved.
//

import Foundation

/// This protocol represents a backend server configuration.
public protocol NetworkClientConfiguration {
    /// The base URL of the backend service
    var baseUrl: String { get }
    /// JSON encoder
    var jsonEncoder: JSONEncoder { get }
    /// JSON decoder
    var jsonDecoder: JSONDecoder { get }
}

/// This manager class does all the heavy lifting. Calls the backend code
public final class NetworkClient {

    // MARK: - Properties

    let session: SessionManager
    fileprivate var parseQueue: DispatchQueue

    private(set) var preMiddlewares: [PreMiddleware] = []
    private(set) var postMiddlewares: [PostMiddleware] = []

    // MARK: - Lifecycle

    public init(session: SessionManager) {
        self.session = session
        parseQueue = DispatchQueue(label: "response-parse")
        session.delegate = self
    }

    // MARK: - Middleware

    /// Register pre execution middleware.
    ///
    /// - Parameter middleware: Middleware instance.
    public func register(_ middleware: PreMiddleware) {
        self.preMiddlewares.append(middleware)
    }

    /// Register post execution middleware.
    ///
    /// - Parameter middleware: Middleware instance.
    public func register(_ middleware: PostMiddleware) {
        self.postMiddlewares.append(middleware)
    }
}

// MARK: - DataRequest

extension NetworkClient {

    /// Perform DataRequest when Void response is expected.
    ///
    /// - Parameters:
    ///   - request: DataRequest instance
    ///   - completion: Void Result callback.
    public func execute<Request: DataRequest>(
        request: Request,
        completion: @escaping (Result<Void, Error>) -> Void
    ) where Request.ResponseType == EmptyResponse {
        session.performDataTask(request: request) { (result: Result<EmptyResponse, Error>) in
            let response = result.map { _ in () }
            completion(response)
        }
    }

    /// Perform DataRequest when a single object response is expected.
    ///
    /// - Parameters:
    ///   - request: DataRequest instance
    ///   - completion: Single object Result callback.
    public func execute<Request: DataRequest>(
        request: Request,
        completion: @escaping (Result<Request.ResponseType, Error>) -> Void
    ) {
        session.performDataTask(request: request) { result in
            completion(result)
        }
    }
}

// MARK: - MultipartRequest

extension NetworkClient {

    public func execute<Request: MultipartRequest>(
        request: Request,
        uploadProgress: MultipartRequest.ProgressHandler?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) where Request.ResponseType == EmptyResponse {
        session.performUploadTask(request: request, uploadProgress: uploadProgress) { (result: Result<EmptyResponse, Error>) in
            let response = result.map { _ in () }
            completion(response)
        }
    }

    public func execute<Request: MultipartRequest>(
        request: Request,
        uploadProgress: MultipartRequest.ProgressHandler?,
        completion: @escaping (Result<Request.ResponseType, Error>) -> Void
    ) {
        session.performUploadTask(request: request, uploadProgress: uploadProgress) { result in
            completion(result)
        }
    }
}

// MARK: - SessionManagerDelegate

extension NetworkClient: SessionManagerDelegate {

    public func sessionManager(_ sessionManager: SessionManager, didPerform request: URLRequest, response: URLResponse, data: Data?) throws {
        try postMiddlewares.forEach {
            try $0.didPerform(request, response: response, data: data)
        }
    }

    public func sessionManager(_ sessionManager: SessionManager, willPerform request: URLRequest) throws {
        try preMiddlewares.forEach {
            try $0.willPerform(request)
        }
    }
}
