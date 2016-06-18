//
//  Network.swift
//  Bike Compass
//
//  Created by Raúl Riera on 23/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation
import Decodable

public struct Network {
    public let id: String
    public let name: String
    public let href: String
    public let location: Location
}

extension Network: Decodable {
    public static func decode(_ j: AnyObject) throws -> Network {
        return try Network(
            id: j => "id",
            name: j => "name",
            href: j => "href",
            location: j => "location"
        )
    }
}

extension Network: Encodable {
    public func encode() -> AnyObject {
        return ["id": id,
                "name": name,
                "href": href,
                "location": location.encode()]
    }
}

public func ==(lhs: Network, rhs: Network) -> Bool {
    return lhs.id == rhs.id
}
