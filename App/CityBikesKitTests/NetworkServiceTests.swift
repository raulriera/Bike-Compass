//
//  NetworkServiceTests.swift
//  Bike Compass
//
//  Created by Raúl Riera on 25/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import XCTest
@testable import CityBikesKit

class NetworkServiceTests: XCTestCase {

    func testReturnedStationsAreFromDublinBikes() {
        let expectation = expectationWithDescription("Dublin Bikes Stations are returned")
        let endpoint = StationsEndpoint(networkId: "dublinbikes")
        
        NetworkService().request(endpoint) { response in
            switch response {
            case .Success(let stations):
                expectation.fulfill()
                XCTAssertEqual(stations.count, 101)
            case .Failure(let error):
                XCTAssertNil(error)
            }
        }
        
        waitForExpectationsWithTimeout(5) { error in
            XCTAssertNil(error, "The request took too long to complete.")
        }
    }
    
    func testReturnedNetworksAreInTheHundreds() {
        let expectation = expectationWithDescription("Hundreds networks are returned")
        let endpoint = NetworksEndpoint()
        
        NetworkService().request(endpoint) { response in
            switch response {
            case .Success(let networks):
                expectation.fulfill()
                XCTAssertGreaterThan(networks.count, 400)
            case .Failure(let error):
                XCTAssertNil(error)
            }
        }
        
        waitForExpectationsWithTimeout(5) { error in
            XCTAssertNil(error, "The request took too long to complete.")
        }
    }
    
}
