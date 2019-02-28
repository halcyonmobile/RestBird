//
//  Request.swift
//  RestBird
//
//  Created by Botond Magyarosi on 04/10/2018.
//

import Foundation

public typealias RequestHeaders    = [String: Any]
public typealias RequestParameters = [String: Any]

/// Abstract REST request protocol.
public protocol Request {
    associatedtype ResponseType: Decodable
    typealias RequestParameterType = Encodable

    /// The HTTP Method of the request. Default: `.get`.
    var method: HTTPMethod { get }

    /// The url suffix of the request. Default: `nil`
    var suffix: String? { get }

    /// Additional headers for the request. Default: `nil`.
    var headers: RequestHeaders? { get }

    /// Request parameters type. Default `nil`.
    var parameters: RequestParameterType? { get }

    /// If true, networking layer will print information about this request to the console. False by default.
    var isDebugModeEnabled: Bool { get }
    
    /// Parameter encoding for the request. Default: `.url` in case of .get, .head HTTPMethod, `.json` in case of .post, .put, .delete, .patch HTTPMethod
    var parameterEncoding: ParameterEncoding { get }
}

extension Request {

    public var method: HTTPMethod { return .get }
    
    public var suffix: String? { return nil }

    public var headers: RequestHeaders? { return nil }

    public var parameters: RequestParameterType? { return nil }

    public var isDebugModeEnabled: Bool { return false }
    
    public var parameterEncoding: ParameterEncoding { return method.defaultParameterEncoding }
}
