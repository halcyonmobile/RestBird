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

    init(session: URLSession = .shared) {
        self.session = session
    }

    public func performDataTask<Request: DataRequest>(request: Request, baseUrl: String, completion: @escaping (Result<Data>) -> Void) {
        fatalError("Not implemented")
    }

    public func performUploadTask<Request: UploadRequest>(request: Request, baseUrl: String, completion: @escaping (Result<Data>) -> Void) {
        fatalError("Not implemented")
    }
}
