//
//  ParameterEncoding.swift
//  RestBird
//
//  Created by Valter Mak on 2/6/19.
//

import Foundation
import Alamofire

public enum ParameterEncoding {
    case url
    case json
    case custom(Alamofire.ParameterEncoder)
}
