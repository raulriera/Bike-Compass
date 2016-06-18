//
//  Location.swift
//  Bike Compass
//
//  Created by Raúl Riera on 23/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation
import Decodable
import CoreLocation

public struct Location {
    public let coordinates: CLLocationCoordinate2D
    public let city: String
    public let country: String
    private let countryCode: String
}

extension Location: Decodable {
    public static func decode(_ j: AnyObject) throws -> Location {
        return try Location(
            coordinates: CLLocationCoordinate2D(latitude: j => "latitude", longitude: j => "longitude"),
            city: j => "city",
            country: Location.transformCountryCodeToDisplayName(j => "country"),
            countryCode: j => "country"
        )        
    }
    
    static func transformCountryCodeToDisplayName(_ code: String) -> String {
        return Locale.system().displayName(forKey: Locale.Key.countryCode, value: code) ?? code
    }
}

extension Location: Encodable {
    public func encode() -> AnyObject {
        return ["latitude": coordinates.latitude,
                "longitude": coordinates.longitude,
                "city": city,
                "country": countryCode]
    }
}
