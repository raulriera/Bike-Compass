//
//  CollectionType+Station.swift
//  Bike Compass
//
//  Created by Raúl Riera on 04/05/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation
import CoreLocation

public extension CollectionType where Generator.Element == Station {
    
    public func sortByProximityToLocation(location: CLLocation) -> [Station] {
        return sort { a, b in
            let locationA = CLLocation(latitude: a.coordinates.latitude, longitude: a.coordinates.longitude)
            let locationB = CLLocation(latitude: b.coordinates.latitude, longitude: b.coordinates.longitude)
            
            return location.distanceFromLocation(locationA) < location.distanceFromLocation(locationB)
        }
    }
    
}