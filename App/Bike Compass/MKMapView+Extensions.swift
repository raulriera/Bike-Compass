//
//  MKMapView+Extensions.swift
//  Bike Compass
//
//  Created by Raúl Riera on 04/05/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import UIKit
import MapKit

/// Apparently, Apple does these things as global functions
func MKMapRectForCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> MKMapRect {
    var rect = MKMapRectNull
    
    for coordinate in coordinates {
        let point = MKMapPointForCoordinate(coordinate)
        rect = MKMapRectUnion(rect, MKMapRectMake(point.x, point.y, 0, 0))
    }
    
    return rect
}
