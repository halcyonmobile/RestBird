//
//  Request+Alamofire.swift
//  Alamofire
//
//  Created by Botond Magyarosi on 24/04/2019.
//

import Foundation
import Alamofire

extension Request {

    func afEncoder(encoder: JSONEncoder) -> Alamofire.ParameterEncoder {
        switch parameterEncoding {
        case .url: return URLEncodedFormParameterEncoder()
        case .json: return JSONParameterEncoder(encoder: encoder)
        case .custom(let encoder): return encoder
        }
    }
    
    var afMethod: Alamofire.HTTPMethod {
        switch method {
        case .get: return .get
        case .head: return .head
        case .post: return .post
        case .put: return .put
        case .delete: return .delete
        case .patch: return .patch
        }
    }

    var afHeaders: Alamofire.HTTPHeaders? {
        guard let _headers: [String: String] = (headers?.compactMapValues { String(describing: $0) }) else { return nil }
        return HTTPHeaders(_headers)
    }

    func afParameters(using encoder: JSONEncoder) throws -> Alamofire.Parameters? {
        guard let parameters = parameters else { return nil }
        let data = try encoder.encode(parameters)
        return try JSONSerialization.jsonObject(with: data, options: []) as? Alamofire.Parameters
    }
}
