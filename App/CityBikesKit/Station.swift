//
//  Station.swift
//  Bike Compass
//
//  Created by Raúl Riera on 23/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation
import Decodable
import CoreLocation

public struct Station {
    public let id: String
    public let name: String
    public let coordinates: CLLocationCoordinate2D
    public let emptySlots: Int
    public let numberOfBikes: Int
    public let lastUpdated: Date?
}

extension Station: Decodable {
    public static func decode(_ j: AnyObject) throws -> Station {
        return try Station(
            id: j => "id",
            name: j => "name",
            coordinates: CLLocationCoordinate2D(latitude: j => "latitude", longitude: j => "longitude"),
            emptySlots: j => "empty_slots",
            numberOfBikes: j => "free_bikes",
            lastUpdated: try? Date.decode(j => "timestamp")
        )
    }
}

extension Station: Encodable {
    public func encode() -> AnyObject {
        return ["id": id,
                "name": name,
                "latitude": coordinates.latitude,
                "longitude": coordinates.longitude,
                "empty_slots": emptySlots,
                "free_bikes": numberOfBikes]
    }
}
