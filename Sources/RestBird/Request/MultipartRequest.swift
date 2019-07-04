//
//  MultipartRequest.swift
//  Alamofire
//
//  Created by Botond Magyarosi on 24/06/2019.
//

import Foundation

public enum Multipart {
    case path(url: URL, name: String)
    case data(data: Data, name: String, fileName: String, mimeType: String)
}

public protocol MultipartRequest: Request {

    /// A closure executed when monitoring upload progress of a request.
    typealias ProgressHandler = (Progress) -> Void

    /// The HTTP Method of the request. Default: `.post`.
    var method: HTTPMethod { get }

    var part: Multipart? { get }
}

extension MultipartRequest {

    public var method: HTTPMethod { return .post }

    public var part: Multipart? { return nil }
}
