//
//  StationsEndpoint.swift
//  Bike Compass
//
//  Created by Raúl Riera on 23/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation
import Decodable

struct StationsEndpoint: EndpointType {
    typealias Response = [Station]
    var path: String {
        return "/networks/\(networkId)"
    }
    let networkId: String
    
    init(networkId: String) {
        self.networkId = networkId
    }
    
    func responseFrom(_ object: AnyObject, URLResponse: HTTPURLResponse) -> Response? {
        return try? [Station].decode(object => "network" => "stations")
    }
}
