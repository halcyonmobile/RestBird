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
    ///   - completion: Request completion handler.
    func performDataTask<Request: DataRequest>(request: Request, completion: @escaping (Result<Data>) -> Void)

    /// Perform upload task
    ///
    /// - Parameters:
    ///   - request: UploadRequest object.
    ///   - completion: Request completion handler.
    func performUploadTask<Request: UploadRequest>(request: Request, completion: @escaping (Result<Data>) -> Void)
}
