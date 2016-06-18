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
        let expectation = self.expectation(withDescription: "Dublin Bikes Stations are returned")
        let endpoint = StationsEndpoint(networkId: "dublinbikes")
        
        NetworkService().request(endpoint) { response in
            switch response {
            case .success(let stations):
                expectation.fulfill()
                XCTAssertEqual(stations.count, 101)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
        
        waitForExpectations(withTimeout: 5) { error in
            XCTAssertNil(error, "The request took too long to complete.")
        }
    }
    
    func testReturnedNetworksAreInTheHundreds() {
        let expectation = self.expectation(withDescription: "Hundreds networks are returned")
        let endpoint = NetworksEndpoint()
        
        NetworkService().request(endpoint) { response in
            switch response {
            case .success(let networks):
                expectation.fulfill()
                XCTAssertGreaterThan(networks.count, 400)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
        
        waitForExpectations(withTimeout: 5) { error in
            XCTAssertNil(error, "The request took too long to complete.")
        }
    }
    
}
