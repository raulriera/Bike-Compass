//
//  DecodableExtensionsTests.swift
//  Bike Compass
//
//  Created by Raúl Riera on 25/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import XCTest
@testable import CityBikesKit
import Alamofire

class DecodableExtensionsTests: XCTestCase {
    
    func testDecodingPerformance() {
        measure { 
            _ = try? Date.decode("2016-04-24T14:15:09.16Z")
        }
    }
    
    /// Not very confident about this test, I think the `encode` method could be bugged
    func testEncodingDatesToString() {
        let expected = "2016-04-24T14:15:09.160Z"
        
        guard let date = try? Date.decode(expected), decoded = date.encode() as? String else {
            XCTFail("There was a problem parsing or decoding the date")
            return
        }
        
        XCTAssertEqual(decoded, expected)
    }
    
    func testDecodingDatesFromString() {
        guard let date = try? Date.decode("2016-04-24T14:15:09.16Z") else {
            XCTFail("There was a problem parsing the date")
            return
        }
        
        let calendar = Calendar.current()
        calendar.timeZone = TimeZone(name: "UTC")!
        let components = calendar.components([.day, .month, .year, .hour, .minute, .second], from: date)
        
        XCTAssertEqual(components.year, 2016)
        XCTAssertEqual(components.month, 4)
        XCTAssertEqual(components.day, 24)
        XCTAssertEqual(components.hour, 14)
        XCTAssertEqual(components.minute, 15)
        XCTAssertEqual(components.second, 9)
    }
    
}
