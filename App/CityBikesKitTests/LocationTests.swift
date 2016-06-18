//
//  LocationTests.swift
//  Bike Compass
//
//  Created by Raúl Riera on 28/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import XCTest
@testable import CityBikesKit

class LocationTests: XCTestCase {
    
    func testDecodingPerformance() {
        measure {
            _ = Location.transformCountryCodeToDisplayName("VEN")
        }
    }
    
    func testTransformCountryCodeToDisplayName() {
        XCTAssertEqual(Location.transformCountryCodeToDisplayName("VEN"), "Venezuela")
        XCTAssertEqual(Location.transformCountryCodeToDisplayName("INVALID_CODE"), "INVALID_CODE", "Should return the code if transformation fails")
    }
        
}
