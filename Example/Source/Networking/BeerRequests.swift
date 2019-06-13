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

    // THIS IS JUST AN EXAMPLE REQUEST
    // BEER API DOES NOT SUPPORT POSTING NEW ITEMS
    // 
    struct Create: UploadRequest {
        typealias ResponseType = EmptyResponse
        typealias RequestType = CreateBeerDTO

        let suffix: String? = "/beers"
        let method: HTTPMethod = .post
        let parameters: CreateBeerDTO?
        let source: UploadSource
    }
}
