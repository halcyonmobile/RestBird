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
    
    /// Default multipart with the following format: `(name: "image", fileName: "image.png", mimeType: "image/png")`.
    public static let multipart: UploadSource = .multipart(mimeType: .imagePNG)
    
    /// Returns a multipart UploadSource for the specified mime type with default name and file name with the following format: `(name: "image", fileName: "image.*", mimeType: mimeType)`.
    public static func multipart(mimeType: MimeType) -> UploadSource {
        return .multipart(name: .name, fileName: .fileName(for: mimeType), mimeType: mimeType)
    }
}

/// Represents an upload request.
public protocol UploadRequest: Request {
    
    /// A closure executed when monitoring upload progress of a request.
    typealias ProgressHandler = (Progress) -> Void
    
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
    
    /// Returns a file name for the specified mime type.
    ///
    /// - Parameters:
    ///   - name: The name of the file. Default is `"image"`.
    ///   - mimeType: The mime type based on which the file name extension will be created.
    /// - Returns: A String representing the file name. E.g. `"image.png"`.
    static func fileName(with name: String = .name, for mimeType: UploadSource.MimeType) -> String {
        let `extension`: String
        
        switch mimeType {
        case .imagePNG:
            `extension` = "png"
        case .imageJPG:
            `extension` = "jpg"
        }
        
        return name + "." + `extension`
    }
}
