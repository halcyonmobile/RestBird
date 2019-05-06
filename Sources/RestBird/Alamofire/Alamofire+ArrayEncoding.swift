//
//  Alamofire+ArrayEncoding.swift
//  Monday
//
//  Created by Valter Mak on 4/28/19.
//

import Foundation
import Alamofire

public struct ArrayEncoding<T: Encodable>: Alamofire.ParameterEncoding {
    
    private let array: T
    
    public init(array: T) {
        self.array = array
    }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(array)
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            urlRequest.httpBody = data
            
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        
        return urlRequest
    }
}
