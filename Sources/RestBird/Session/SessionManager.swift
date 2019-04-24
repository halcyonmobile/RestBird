//
//  SessionManager.swift
//  RestBird
//
//  Created by Botond Magyarosi on 02/10/2018.
//  Copyright © 2018 Halcyon Mobile. All rights reserved.
//

import Foundation

public protocol SessionManagerDelegate: class {

    /// Informs delegate that a URLRequest is about to be executed.
    ///
    /// - Parameters:
    ///   - sessionManager: SessionManager instance.
    ///   - request: URLRequest instance.
    /// - Throws: The delegate can throw if preconditions are not met.
    func sessionManager(_ sessionManager: SessionManager, willPerform request: URLRequest) throws

    /// Informs delegate that a URLRequest was executed.
    ///
    /// - Parameters:
    ///   - sessionManager: SessionManager instance.
    ///   - request: URLRequest instance.
    ///   - response: URLResponse instance.
    ///   - data: response data.
    /// - Throws: The delegate can throw if postconditions are not met.
    func sessionManager(_ sessionManager: SessionManager, didPerform request: URLRequest, response: URLResponse, data: Data?) throws
}

/// URL session interface
public protocol SessionManager: class {

    var config: NetworkClientConfiguration { get }

    /// Delegate for ULR request state callbacks.
    /// !!! DO NOT OVERRIDE THIS VARIABLE !!!
    var delegate: SessionManagerDelegate? { get set }

    /// Perform data task.
    ///
    /// - Parameters:
    ///   - request: DataRequest instance.
    ///   - baseUrl: The base URL for the upload task.
    ///   - completion: Request completion handler.
    func performDataTask<Request: DataRequest>(request: Request, completion: @escaping (Result<Data, Error>) -> Void)

    /// Perform upload task.
    ///
    /// - Parameters:
    ///   - request: URLRequest instance.
    ///   - source: Upload source type.
    ///   - completion: Request completion handler.
    func performUploadTask<Request: UploadRequest>(request: Request, source: UploadSource, completion: @escaping (Result<Data, Error>) -> Void)
    
    /// Perform upload task.
    ///
    /// - Parameters:
    ///   - request: URLRequest instance.
    ///   - source: Upload source type.
    ///   - uploadProgress: The closure used to monitor the progress of the upload request.
    ///   - completion: Request completion handler.
    func performUploadTask<Request: UploadRequest>(request: Request, source: UploadSource, uploadProgress: UploadRequest.ProgressHandler?, completion: @escaping (Result<Data, Error>) -> Void)
}
