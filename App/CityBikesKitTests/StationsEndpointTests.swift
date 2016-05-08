//
//  StationsEndpointTests.swift
//  Bike Compass
//
//  Created by Raúl Riera on 23/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import XCTest
@testable import CityBikesKit

class StationsEndpointTests: XCTestCase {
    let endpoint = StationsEndpoint(networkId: "dublinbikes")
        
    func testPathIsCorrect() {
        XCTAssertEqual(endpoint.path, "/networks/dublinbikes")
    }
    
    func testResponseFromObject() {
        let URLResponse = NSHTTPURLResponse(URL: NSURL(string: "http://api.citybik.es/")!, statusCode: 200, HTTPVersion: nil, headerFields: nil)!
        let json = loadJSON("stations")!
        
        let stations = endpoint.responseFromObject(json, URLResponse: URLResponse)
        
        XCTAssertEqual(stations?.count, 1)
        XCTAssertEqual(stations?.first?.name, "FENIAN STREET")
    }
        
}
