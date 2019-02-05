//
//  ErrorMiddleware.swift
//  iOS Example
//
//  Created by Botond Magyarosi on 05/02/2019.
//  Copyright © 2019 Botond Magyarosi. All rights reserved.
//

import Foundation
import RestBird

enum CodingError: Error {
    case unknownValue
}

enum NetworkError: Int, Error, Decodable {
    case foo = 25
    case bar = 26

    enum CodingKeys: String, CodingKey {
        case id
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        guard let error = NetworkError(rawValue: id) else {
            throw CodingError.unknownValue
        }
        self = error
    }
}

struct ErrorMiddleware: PostMiddleware {

    func didPerform(_ request: URLRequest, response: URLResponse, data: Data?) throws {
        guard let data = data else { return }
        var error: NetworkError?
        do {
            error = try JSONDecoder().decode(NetworkError.self, from: data)
        } catch { }
        if let error = error {
            throw error
        }
    }
}
