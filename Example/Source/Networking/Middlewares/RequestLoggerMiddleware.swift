//
//  RequestLoggerMiddleware.swift
//  iOS Example
//
//  Created by Botond Magyarosi on 05/02/2019.
//  Copyright © 2019 Botond Magyarosi. All rights reserved.
//

import Foundation
import RestBird

class RequestLoggerMiddleware: PreMiddleware {

    func willPerform(_ request: URLRequest) throws {
        if let url = request.url {
            print("[Networking] Perform request: \(url)")
        }
        print("[Networking] Headers: \(request.allHTTPHeaderFields ?? [:])")
    }
}
