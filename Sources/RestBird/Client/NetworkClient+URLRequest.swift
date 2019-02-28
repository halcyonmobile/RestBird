//
//  NetworkClient+URLRequest.swift
//  Alamofire
//
//  Created by Botond Magyarosi on 28/02/2019.
//

import Foundation

extension Request {

    func toUrlRequest(using config: NetworkClientConfiguration) throws -> URLRequest {
        var urlString: String
        if let suffix = suffix {
            urlString = config.baseUrl + suffix
        } else {
            urlString = config.baseUrl
        }

        guard let url = URL(string: urlString) else { throw NetworkError.malformedURL }
        var urlRequest = URLRequest(url: url)

        headers?.forEach { (key, value) in
            urlRequest.setValue(String(describing: value), forHTTPHeaderField: key)
        }

        if parameterEncoding == .json {
            /// JSON Encoding
            if let parameters = parameters {
                do {
                    urlRequest.httpBody = try config.jsonEncoder.encode(parameters)
                } catch {
                    throw NetworkError.parameterEncodingFailed
                }
            }
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } else {
            if let query = queryString(for: parameters) {
                urlString += "?\(query)"
            }
        }

        return urlRequest
    }

    private func queryString(for parameters: [String: Any]?) -> String? {
        guard let parameters = parameters else { return nil }
        let query = parameters.mapValues { String(describing: $0) }.map { "\($0)=\($1)" }.joined(separator: "&")
        return query
    }

    func includeParamsInQuery<A: Request>(request: A) -> Bool {
        switch method {
        case .get, .head, .delete: return true
        case .post, .put, .patch: return false
        }
    }
}
