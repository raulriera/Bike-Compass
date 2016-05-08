//
//  CollectionType+Network.swift
//  Bike Compass
//
//  Created by Raúl Riera on 26/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation
import CoreLocation

public extension CollectionType where Generator.Element == Network {

    public func sortByCity() -> [Network] {
        return sort {
            $0.location.city < $1.location.city
        }
    }
    
    public func sortByProximityToLocation(location: CLLocation) -> [Network] {
        return sort { a, b in
            let locationA = CLLocation(latitude: a.location.coordinates.latitude, longitude: a.location.coordinates.longitude)
            let locationB = CLLocation(latitude: b.location.coordinates.latitude, longitude: b.location.coordinates.longitude)
            
            return location.distanceFromLocation(locationA) < location.distanceFromLocation(locationB)
        }
    }
    
}