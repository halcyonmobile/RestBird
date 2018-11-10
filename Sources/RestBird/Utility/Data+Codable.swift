//
//  Data+Codable.swift
//  RestBird
//
//  Created by Botond Magyarosi on 01/10/2018.
//  Copyright © 2018 Halcyon Mobile. All rights reserved.
//

import Foundation

// MARK: Encodable -> Data

extension Encodable {

    /// Encode JSON data type object into Data.
    ///
    /// - Parameter encoder: encoder instance. default `JSONEncoder()`.
    /// - Returns: encoded data.
    /// - Throws: error in case of encoding error.
    func encoded(encoder: JSONEncoder) throws -> Data {
        return try encoder.encode(self)
    }
}

// MARK: Data -> Decodable

extension Data {

    /// Decode Data into a Decodable object.
    ///
    /// - Parameter decoder: decoder instance. default `JSONDecoder()`.
    /// - Returns: decoded json object.
    /// - Throws: error in case of decoding error.
    func decoded<T: Decodable>(decoder: JSONDecoder) throws -> T {
        return try decoder.decode(T.self, from: self)
    }

    /// Decode data into an array of Decodable objects.
    ///
    /// - Parameter decoder: decoder instance. default `JSONDecoder()`.
    /// - Returns: decoded array of json objects.
    /// - Throws: error in case of decoding error.
    func decodedArray<T: Decodable>(decoder: JSONDecoder) throws -> [T] {
        return try decoder.decode([T].self, from: self)
    }
}
