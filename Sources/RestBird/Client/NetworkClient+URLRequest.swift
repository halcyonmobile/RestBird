//
//  NetworkClient+URLRequest.swift
//  Alamofire
//
//  Created by Botond Magyarosi on 28/02/2019.
//

import Foundation

extension Encodable {

    func encoded(using: JSONEncoder) throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

extension Request {

    func toUrlRequest(using config: NetworkClientConfiguration) throws -> URLRequest {
        let urlString = try self.urlString(using: config)
        guard let url = URL(string: urlString) else { throw NetworkError.malformedURL }
        var urlRequest = URLRequest(url: url)

        headers?.forEach { (key, value) in
            urlRequest.setValue(String(describing: value), forHTTPHeaderField: key)
        }

        if parameterEncoding == .json {
            do {
                urlRequest.httpBody = try parameters?.encoded(using: config.jsonEncoder)
            } catch {
                throw NetworkError.parameterEncodingFailed
            }
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } else if parameterEncoding == .url && method.defaultParameterEncoding == .json {
            if let string = queryString(using: config) {
                urlRequest.httpBody = string.data(using: .utf8)
            }
        }

        return urlRequest
    }

    private func queryString(using config: NetworkClientConfiguration) -> String? {
        guard let parameters = parameters else { return nil }
        do {
            let data = try parameters.encoded(using: config.jsonEncoder)
            let paramsDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            return paramsDict?.mapValues { String(describing: $0) }.map { "\($0)=\($1)" }.joined(separator: "&")
        } catch {
            return nil
        }
    }

    private func urlString(using config: NetworkClientConfiguration) throws -> String {
        var urlString: String
        if let suffix = suffix {
            urlString = config.baseUrl + suffix
        } else {
            urlString = config.baseUrl
        }
        if parameterEncoding == .url, method.defaultParameterEncoding == .url, let query = queryString(using: config) {
            urlString += "?\(query)"
        }
        return urlString
    }
}
