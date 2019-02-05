//
//  Middleware.swift
//  Alamofire
//
//  Created by Botond Magyarosi on 16/01/2019.
//

import Foundation

public protocol PreMiddleware {

    /// NetworkClient will call this method before executing a network request.
    ///
    /// - Parameter request: network request instance.
    /// - Throws: the method might throw to prevent execution.
    func willPerform(_ request: URLRequest) throws
}

public protocol PostMiddleware {

    /// NetworkClient will call this method after executing a network request.
    ///
    /// - Parameters:
    ///   - request: network request instance.
    ///   - response: response instance.
    ///   - data: response data.
    /// - Throws: the method might throw to prevent futher execution.
    func didPerform(_ request: URLRequest, response: URLResponse, data: Data?) throws
}
