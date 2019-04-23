//
//  MainAPIConfiguration.swift
//  iOS Example
//
//  Created by Botond Magyarosi on 16/10/2018.
//  Copyright © 2018 Botond Magyarosi. All rights reserved.
//

import Foundation
import RestBird

struct MainAPIConfiguration: NetworkClientConfiguration {
    let baseUrl = "https://api.punkapi.com/v2"
    let sessionManager: SessionManager = AlamofireSessionManager()
    let jsonEncoder: JSONEncoder
    let jsonDecoder: JSONDecoder

    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-yyyy"
        jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        jsonEncoder.dateEncodingStrategy = .formatted(dateFormatter)
        jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
}
