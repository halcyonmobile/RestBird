//
//  Result.swift
//  RestBird
//
//  Created by Botond Magyarosi on 01/10/2018.
//  Copyright © 2018 Halcyon Mobile. All rights reserved.
//

import Foundation

public enum Result<Element> {
    case success(Element)
    case failure(Error)
}

extension Result {

    /// Map Result type into another result type
    ///
    /// - Parameter transform: transform function
    /// - Returns: a Result type with different constrained value
    /// - Throws: Error if transform is not possible
    func map<T>(_ transform: (Element) throws -> T) -> Result<T> {
        switch self {
        case .success(let element):
            do {
                return try .success(transform(element))
            } catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
