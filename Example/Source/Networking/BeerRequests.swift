//
//  BeerRequests.swift
//  iOS Example
//
//  Created by Botond Magyarosi on 16/10/2018.
//  Copyright © 2018 Botond Magyarosi. All rights reserved.
//

import Foundation
import RestBird

extension Request.Beer {

    struct GetAll: DataRequest {
        typealias ResponseType = [Beer]
        typealias RequestType = FilterBeerDTO

        var suffix: String? = "/beers"
        var parameters: FilterBeerDTO?
    }

    struct Create: DataRequest {
        typealias ResponseType = EmptyResponse
        typealias RequestType = CreateBeerDTO

        var suffix: String? = "/beers"
        var method: HTTPMethod = .post
        var parameters: CreateBeerDTO?
    }
}
