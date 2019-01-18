//
//  NetworkClient+Rx.swift
//  RestBird
//
//  Created by Mate Mellau on 1/17/19.
//  Copyright © 2019 Halcyon Mobile. All rights reserved.
//

import RestBird
import RxSwift

extension NetworkClient: ReactiveCompatible {}

extension Reactive where Base: NetworkClient {

    public func execute<Request: DataRequest>(request: Request) -> Observable<RestBird.Result<Void>> where Request.ResponseType == EmptyResponse {
        return Observable<RestBird.Result<Void>>.deferred { [weak base] in
            return Observable.create { observer -> Disposable in
                base?.execute(request: request) { (result: RestBird.Result<Void>) in
                    observer.onNext(result)
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        }
    }

    public func execute<Request: DataRequest>(request: Request) -> Observable<RestBird.Result<Request.ResponseType>> {
        return Observable<RestBird.Result<Request.ResponseType>>.deferred { [weak base] in
            return Observable.create { observer -> Disposable in
                base?.execute(request: request) { (result: RestBird.Result<Request.ResponseType>) in
                    observer.onNext(result)
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        }
    }

    public func execute<Request: DataRequest>(request: Request) -> Observable<RestBird.Result<[Request.ResponseType]>> {
        return Observable<RestBird.Result<[Request.ResponseType]>>.deferred { [weak base] in
            return Observable.create { observer -> Disposable in
                base?.execute(request: request) { (result: RestBird.Result<[Request.ResponseType]>) in
                    observer.onNext(result)
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        }
    }
}
