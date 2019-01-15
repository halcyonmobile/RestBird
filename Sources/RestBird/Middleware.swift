//
//  Middleware.swift
//  Alamofire
//
//  Created by Botond Magyarosi on 16/01/2019.
//

import Foundation

protocol PreMiddleware {
    func willPerform(_ request: URLRequest) throws
}

protocol PostMiddleware {
    func didPerform(_ request: URLRequest, response: URLResponse) throws
}
