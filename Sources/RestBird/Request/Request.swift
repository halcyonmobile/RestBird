//
//  Request.swift
//  RestBird
//
//  Created by Botond Magyarosi on 04/10/2018.
//

import Foundation

/// Abstract REST request protocol.
public protocol Request {
    associatedtype ResponseType: Decodable

    /// The HTTP Method of the request. Default: `.get`.
    var method: HTTPMethod { get }

    /// The url suffix of the request. Default: `nil`
    var suffix: String? { get }

    /// Additional headers fir the request. Default: `nil`.
    var headers: [String: Any]? { get }
}

extension Request {

    var method: HTTPMethod { return .get }
    
    var suffix: String? { return nil }

    var headers: [String: Any]? { return nil }
}
