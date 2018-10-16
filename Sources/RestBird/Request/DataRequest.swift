//
//  DataRequest.swift
//  RestBird
//
//  Created by Botond Magyarosi on 04/10/2018.
//

import Foundation

/// Represents a network request
public protocol DataRequest: Request {
    /// The parameter dictionary of the request. Default: nil
    var parameters: [String: Any]? { get }
}

// default implementations

extension DataRequest {
    public var parameters: [String: Any]? { return nil }
}
