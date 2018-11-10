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
    /// Define session manager interface. Can be Alamofire, URLSession
    var sessionManager: SessionManager { get }
    /// JSON encoder
    var jsonEncoder: JSONEncoder { get }
    /// JSON decoder
    var jsonDecoder: JSONDecoder { get }
}

/// This manager class does all the heavy lifting. Calls the backend code
public class NetworkClient {

    // MARK: - Properties

    fileprivate let config: NetworkClientConfiguration
    fileprivate var parseQueue: DispatchQueue

    // MARK: - Lifecycle

    public init(configuration: NetworkClientConfiguration) {
        self.config = configuration
        parseQueue = DispatchQueue(label: "response-parse")
    }
}

// MARK: - Data request

extension NetworkClient {

    public func execute<Request: DataRequest>(request: Request, completion: @escaping (Result<Void>) -> Void)  where Request.ResponseType == EmptyResponse {
        performDataTask(request: request) { result in
            self.parseQueue.async {
                let response = result.map { _ in () }
                DispatchQueue.main.async {
                    completion(response)
                }
            }
        }
    }

    public func execute<Request: DataRequest>(request: Request, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<Request.ResponseType>) -> Void) {
        performDataTask(request: request) { [config] result in
            self.parseQueue.async {
                let response: Result<Request.ResponseType> = result.map { [config] in try $0.decoded(decoder: config.jsonDecoder) }
                DispatchQueue.main.async {
                    completion(response)
                }
            }
        }
    }

    public func execute<Request: DataRequest>(request: Request, completion: @escaping (Result<[Request.ResponseType]>) -> Void) {
        performDataTask(request: request) { [config] result in
            self.parseQueue.async {
                let response: Result<[Request.ResponseType]> = result.map { try $0.decodedArray(decoder: config.jsonDecoder) }
                DispatchQueue.main.async {
                    completion(response)
                }
            }
        }
    }

    // MARK: - Private

    private func performDataTask<Request: DataRequest>(request: Request, completion: @escaping (Result<Data>) -> Void) {
        config.sessionManager.performDataTask(request: request, baseUrl: config.baseUrl, completion: completion)
    }
}

// MARK: - Upload request

extension NetworkClient {

    public func execute<Request: UploadRequest>(request: Request, completion: @escaping (Result<Request.ResponseType>) -> Void) {
        performUploadTask(request: request) { [config] result in
            self.parseQueue.async {
                let response: Result<Request.ResponseType> = result.map { try $0.decoded(decoder: config.jsonDecoder) }
                DispatchQueue.main.async {
                    completion(response)
                }
            }
        }
    }

    // MARK: - Private

    private func performUploadTask<Request: UploadRequest>(request: Request, completion: @escaping (Result<Data>) -> Void) {
        config.sessionManager.performUploadTask(request: request, baseUrl: config.baseUrl, completion: completion)
    }
}
