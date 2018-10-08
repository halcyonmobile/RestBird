//
//  URLSessionManager.swift
//  RestBird
//
//  Created by Botond Magyarosi on 02/10/2018.
//  Copyright © 2018 Halcyon Mobile. All rights reserved.
//

import Foundation

class URLSessionManager: SessionManager {

    private(set) var session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func performDataTask<Request: DataRequest>(request: Request, completion: @escaping (Result<Data>) -> Void) {
        fatalError("Not implemented")
    }

    func performUploadTask<Request: UploadRequest>(request: Request, completion: @escaping (Result<Data>) -> Void) {
        fatalError("Not implemented")
    }
}
