//
//  StationPointAnnotation.swift
//  Bike Compass
//
//  Created by Raúl Riera on 29/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation
import CityBikesKit
import MapKit

class StationPointAnnotation: MKPointAnnotation {
    let station: Station
    
    init(station: Station) {
        self.station = station
        
        super.init()
        
        title = station.name
        subtitle = "\(station.numberOfBikes) bikes and \(station.emptySlots) spots left"
        coordinate = station.coordinates
    }
    
}