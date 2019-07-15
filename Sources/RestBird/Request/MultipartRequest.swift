//
//  MultipartRequest.swift
//  Alamofire
//
//  Created by Botond Magyarosi on 24/06/2019.
//

import Foundation

public enum Multipart {
    case path(url: URL, name: String)
    case data(data: Data, name: String, fileName: String?, mimeType: String)
    
    public static func data(data: Data, name: String, mimeType: String) -> Multipart {
        return .data(data: data, name: name, fileName: nil, mimeType: mimeType)
    }
}

public protocol MultipartRequest: Request {

    /// A closure executed when monitoring upload progress of a request.
    typealias ProgressHandler = (Progress) -> Void

    /// The HTTP Method of the request. Default: `.post`.
    var method: HTTPMethod { get }

    var parts: [Multipart] { get }
}

extension MultipartRequest {

    public var method: HTTPMethod { return .post }

    public var parts: [Multipart] { return [] }
}
