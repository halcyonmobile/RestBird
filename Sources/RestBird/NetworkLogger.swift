//
//  NetworkLogger.swift
//  RestBird
//
//  Created by Tamas Levente on 2018-10-30.
//

import Foundation

public protocol NetworkLogger {
    func log(request: URLRequest)
}

public class NetworkConsoleLogger: NetworkLogger {
    public init() {}
    
    public func log(request: URLRequest) {
        print("[NETWORK]: Request url: \(request.httpMethod ?? "NA") \(request.url?.absoluteString ?? "NA")")
        print("[NETWORK]: Request headers: \(request.allHTTPHeaderFields ?? [:])")
        if let bodyData = request.httpBody, let bodyString = NSString(data: bodyData, encoding: String.Encoding.utf8.rawValue) {
            print("[NETWORK]: Request body: \(bodyString)")
        }
    }
}
