//
//  HTTPMethod.swift
//  RestBird
//
//  Created by Botond Magyarosi on 01/10/2018.
//  Copyright © 2018 Halcyon Mobile. All rights reserved.
//

import Foundation

/// List of the supported HTTP methods
/// [GET, POST, PUT, DELETE](https://tools.ietf.org/html/rfc7231#section-4)
/// [PATCH](https://tools.ietf.org/html/rfc5789#section-2)
///
/// - get: Transfer a current representation of the target resource.
/// - head: Same as GET, but only transfer the status line and header section.
/// - post: Perform resource-specific processing on the request payload.
/// - put: Replace all current representations of the target resource with the request payload.
/// - delete: Remove all current representations of the target resource.
/// - patch: Apply partial modifications to a resource the target resource.
public enum HTTPMethod {
    case get, head, post, put, delete, patch
}

public struct EmptyResponse: Decodable { }
