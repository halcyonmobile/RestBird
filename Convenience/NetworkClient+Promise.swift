//
//  NetworkClient+Promise.swift
//  RestBird
//
//  Created by Botond Magyarosi on 29/11/2018.
//  Copyright © 2018 Halcyon Mobile. All rights reserved.
//

import RestBird
import PromiseKit

public struct PromiseBase<Base> {
    public let base: Base

    public init(_ base: Base) {
        self.base = base
    }
}

protocol PromiseCompatible {
    associatedtype SomeType
    var promise: SomeType { get }
}

extension PromiseCompatible {

    var promise: PromiseBase<Self> {
        return PromiseBase(self)
    }
}

// MARK: - NetworkClient

extension NetworkClient: PromiseCompatible { }

extension PromiseBase where Base: NetworkClient {

    public func execute<Request: DataRequest>(request: Request) -> Promise<Void> where Request.ResponseType == EmptyResponse {
        return Promise(resolver: { resolver in
            base.execute(request: request) { (result: RestBird.Result<Void>) in
                switch result {
                case .success:
                    resolver.fulfill(())
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        })
    }

    public func execute<Request: DataRequest>(request: Request) -> Promise<Request.ResponseType> {
        return Promise(resolver: { resolver in
            base.execute(request: request) { (result: RestBird.Result<Request.ResponseType>) in
                switch result {
                case .success(let object):
                    resolver.fulfill(object)
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        })
    }

    public func execute<Request: DataRequest>(request: Request) -> Promise<[Request.ResponseType]> {
        return Promise(resolver: { resolver in
            base.execute(request: request) { (result: RestBird.Result<[Request.ResponseType]>) in
                switch result {
                case .success(let array):
                    resolver.fulfill(array)
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        })
    }

    public func execute<Request: UploadRequest>(request: Request) -> Promise<Request.ResponseType> {
        return Promise(resolver: { resolver in
            base.execute(request: request) { (result: RestBird.Result<Request.ResponseType>) in
                switch result {
                case .success(let object):
                    resolver.fulfill(object)
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        })
    }
}
