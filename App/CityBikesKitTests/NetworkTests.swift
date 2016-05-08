//
//  NetworkTests.swift
//  Bike Compass
//
//  Created by Raúl Riera on 09/05/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import XCTest
import MapKit
@testable import CityBikesKit

class NetworkTests: XCTestCase {
    func testEqualityOfNetworks() {
        let locations = try? [Location].decode(loadJSON("locations")!["locations"]!)
        let networkA = Network(id: "1", name: "Network A", href: "/a", location: locations!.first!)
        let networkB = Network(id: "2", name: "Network B", href: "/b", location: locations!.last!)
        let networkC = Network(id: "1", name: "Network C", href: "/c", location: locations!.first!)
        
        XCTAssertFalse(networkA == networkB)
        XCTAssertTrue(networkA == networkC)
    }
}