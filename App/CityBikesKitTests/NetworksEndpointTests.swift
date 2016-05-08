//
//  NetworksEndpointTests.swift
//  CityBikesKitTests
//
//  Created by Raúl Riera on 23/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import XCTest
@testable import CityBikesKit

class NetworksEndpointTests: XCTestCase {
    let endpoint = NetworksEndpoint()
        
    func testPathIsCorrect() {
        XCTAssertEqual(endpoint.path, "/networks")
    }
    
    func testResponseFromObject() {
        let URLResponse = NSHTTPURLResponse(URL: NSURL(string: "http://api.citybik.es/")!, statusCode: 200, HTTPVersion: nil, headerFields: nil)!
        let json = loadJSON("networks")!
        
        let networks = endpoint.responseFromObject(json, URLResponse: URLResponse)
        
        XCTAssertEqual(networks?.count, 5)
        XCTAssertEqual(networks?.last?.name, "Bay Area Bike Share")
    }
        
}
