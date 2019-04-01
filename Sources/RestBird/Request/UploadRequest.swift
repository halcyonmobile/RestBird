//
//  UploadRequest.swift
//  RestBird
//
//  Created by Botond Magyarosi on 04/10/2018.
//

import Foundation

public enum UploadSource {
    case url(URL)
    case data(Data)
    case stream(InputStream)
    case multipart(data: Data, name: String, fileName: String, mimeType: String)
}

/// Represents an upload request.
public protocol UploadRequest: Request {
    
    /// The HTTP Method of the request. Default: `.post`.
    var method: HTTPMethod { get }
    
    /// The source of the request.
    var source: UploadSource { get }
}

extension UploadRequest {
    
    public var method: HTTPMethod { return .post }
}
