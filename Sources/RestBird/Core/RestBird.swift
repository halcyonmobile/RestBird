//
//  RestBird.swift
//  RestBird
//
//  Created by Botond Magyarosi on 01/10/2018.
//  Copyright © 2018 Halcyon Mobile. All rights reserved.
//

import Foundation

/// This protocol represents a backend server configuration.
public protocol RestBirdConfiguration {
    /// The base URL of the backend service
    var baseUrl: String { get }
    /// Define session manager interface. Can be Alamofire, URLSession
    var sessionManager: SessionManager { get }
}

/// This manager class does all the heavy lifting. Calls the backend code
public class RestBird {

    // MARK: - Properties

    fileprivate let config: RestBirdConfiguration
    fileprivate var parseQueue: DispatchQueue

    // MARK: - Lifecycle

    public init(configuration: RestBirdConfiguration) {
        self.config = configuration
        parseQueue = DispatchQueue(label: "response-parse")
    }
}

// MARK: - Data request

extension RestBird {

    public func execute<Request: DataRequest>(request: Request, completion: @escaping (Result<Void>) -> Void) {
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
        performDataTask(request: request) { result in
            self.parseQueue.async {
                let response: Result<Request.ResponseType> = result.map { try $0.decoded() }
                DispatchQueue.main.async {
                    completion(response)
                }
            }
        }
    }

    public func execute<Request: DataRequest>(request: Request, completion: @escaping (Result<[Request.ResponseType]>) -> Void) {
        performDataTask(request: request) { result in
            self.parseQueue.async {
                let response: Result<[Request.ResponseType]> = result.map { try $0.decodedArray() }
                DispatchQueue.main.async {
                    completion(response)
                }
            }
        }
    }

    private func performDataTask<Request: DataRequest>(request: Request, completion: @escaping (Result<Data>) -> Void) {
        config.sessionManager.performDataTask(request: request, completion: completion)
    }
}

// MARK: - Upload request

extension RestBird {

    public func execute<Request: UploadRequest>(request: Request, completion: @escaping (Result<Request.ResponseType>) -> Void) {
        performUploadTask(request: request) { result in
            self.parseQueue.async {
                let response: Result<Request.ResponseType> = result.map { try $0.decoded() }
                DispatchQueue.main.async {
                    completion(response)
                }
            }
        }
    }

    private func performUploadTask<Request: UploadRequest>(request: Request, completion: @escaping (Result<Data>) -> Void) {
        config.sessionManager.performUploadTask(request: request, completion: completion)
    }
}
