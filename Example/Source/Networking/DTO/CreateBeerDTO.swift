//
//  CreateBeerDTO.swift
//  iOS Example
//
//  Created by Botond Magyarosi on 23/04/2019.
//  Copyright © 2019 Botond Magyarosi. All rights reserved.
//

import Foundation

struct CreateBeerDTO: Encodable {
    let name: String
    let brewedBefore: Date
}
