//
//  CollectionTypeNetworkTests.swift
//  Bike Compass
//
//  Created by Raúl Riera on 01/05/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import XCTest
import CoreLocation
@testable import CityBikesKit

class CollectionTypeNetworkTests: XCTestCase {
    var networks: [Network]!
    
    override func setUp() {
        super.setUp()
                
        networks = try? [Network].decode(loadJSON("networks")!["networks"]!)
    }
    
    func testSortByCityAlphabetically() {
        let sorted = networks.sortByCity()
        
        XCTAssertEqual(sorted.first?.location.city, "Dublin")
        XCTAssertEqual(sorted.first?.location.country, "Ireland")
    }
    
    func testSortByLocation() {
        let location = CLLocation(latitude: 53.350140, longitude: -6.266155)
        let sorted = networks.sortByProximityToLocation(location)
        
        XCTAssertEqual(sorted.first?.location.city, "Dublin")
        XCTAssertEqual(sorted.first?.location.country, "Ireland")
    }
}
