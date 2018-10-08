//
//  UploadRequest.swift
//  RestBird
//
//  Created by Botond Magyarosi on 04/10/2018.
//

import Foundation

enum UploadSource {
    case url(URL)
    case data(Data)
    case steam(InputStream)
}

/// Represents an upload request.
protocol UploadRequest: Request {
    var source: UploadSource { get }
}

extension UploadRequest {
    var method: HTTPMethod { return .post }
}
