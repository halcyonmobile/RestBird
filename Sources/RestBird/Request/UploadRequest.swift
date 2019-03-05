//
//  UploadRequest.swift
//  RestBird
//
//  Created by Botond Magyarosi on 04/10/2018.
//

import Foundation

public enum UploadSource {
    
    public enum MimeType: String {
        case imagePNG = "image/png"
        case imageJPG = "image/jpg"
    }
    
    case url(URL)
    case data(Data)
    case stream(InputStream)
    case multipart(name: String, fileName: String, mimeType: MimeType)
    
    public static let multipart: UploadSource = .multipart(name: .name, fileName: .fileName(for: .imagePNG), mimeType: .imagePNG)
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

private extension String {
    
    static let name = "image"
    
    static func fileName(for mimeType: UploadSource.MimeType) -> String {
        let `extension`: String
        
        switch mimeType {
        case .imagePNG:
            `extension` = "png"
        case .imageJPG:
            `extension` = "jpg"
        }
        
        return .name + "." + `extension`
    }
}
