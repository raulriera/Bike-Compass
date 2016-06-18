//
//  NetworksEndpoint.swift
//  CityBikesKit
//
//  Created by Raúl Riera on 23/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation
import Decodable

struct NetworksEndpoint: EndpointType {
    typealias Response = [Network]
    let path = "/networks"
    
    func responseFrom(_ object: AnyObject, URLResponse: HTTPURLResponse) -> Response? {
        return try? [Network].decode(object => "networks")
    }
}
