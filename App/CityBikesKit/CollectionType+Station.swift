//
//  CollectionType+Station.swift
//  Bike Compass
//
//  Created by Raúl Riera on 04/05/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation
import CoreLocation

public extension Collection where Iterator.Element == Station {
    
    public func sortByProximityToLocation(_ location: CLLocation) -> [Station] {
        return sorted { a, b in
            let locationA = CLLocation(latitude: a.coordinates.latitude, longitude: a.coordinates.longitude)
            let locationB = CLLocation(latitude: b.coordinates.latitude, longitude: b.coordinates.longitude)
            
            return location.distance(from: locationA) < location.distance(from: locationB)
        }
    }
    
}
