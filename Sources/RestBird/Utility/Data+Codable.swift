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
    /// - Parameter encoder: encoder instance.
    /// - Returns: encoded data.
    /// - Throws: error in case of encoding error.
    func encoded(using encoder: JSONEncoder) throws -> Data {
        return try encoder.encode(self)
    }
}

// MARK: Data -> Decodable

extension Data {

    /// Decode Data into a Decodable object.
    ///
    /// - Parameters:
    ///   - type: Object type.
    ///   - decoder: decoder instance.
    /// - Returns: decoded json objects.
    /// - Throws: error in case of decoding error.
    func decoded<T: Decodable>(_ type: T.Type, with decoder: JSONDecoder) throws -> T {
        return try decoder.decode(T.self, from: self)
    }
}
