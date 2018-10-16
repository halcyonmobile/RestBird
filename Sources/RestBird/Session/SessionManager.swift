//
//  SessionManager.swift
//  RestBird
//
//  Created by Botond Magyarosi on 02/10/2018.
//  Copyright © 2018 Halcyon Mobile. All rights reserved.
//

import Foundation

/// URL session interface
public protocol SessionManager {

    /// Perform data task.
    ///
    /// - Parameters:
    ///   - request: DataRequest object.
    ///   - baseUrl: The base URL for the upload task.
    ///   - completion: Request completion handler.
    func performDataTask<Request: DataRequest>(request: Request, baseUrl: String, completion: @escaping (Result<Data>) -> Void)

    /// Perform upload task
    ///
    /// - Parameters:
    ///   - request: UploadRequest object.
    ///   - baseUrl: The base URL for the upload task.
    ///   - completion: Request completion handler.
    func performUploadTask<Request: UploadRequest>(request: Request, baseUrl: String, completion: @escaping (Result<Data>) -> Void)
}
