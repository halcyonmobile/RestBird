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

    struct GetAll: DataRequest  {
        typealias ResponseType = [Beer]
        typealias RequestType = EmptyRequest

        var suffix: String? = "/beers"
        var parameters: EmptyRequest?
    }
}
