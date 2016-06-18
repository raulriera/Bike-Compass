//
//  CollectionType+Network.swift
//  Bike Compass
//
//  Created by Raúl Riera on 26/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation
import CoreLocation

public extension Collection where Iterator.Element == Network {

    public func sortByCity() -> [Network] {
        return sorted {
            $0.location.city < $1.location.city
        }
    }
    
    public func sortByProximityToLocation(_ location: CLLocation) -> [Network] {
        return sorted { a, b in
            let locationA = CLLocation(latitude: a.location.coordinates.latitude, longitude: a.location.coordinates.longitude)
            let locationB = CLLocation(latitude: b.location.coordinates.latitude, longitude: b.location.coordinates.longitude)
            
            return location.distance(from: locationA) < location.distance(from: locationB)
        }
    }
    
}
