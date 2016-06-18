//
//  NSDate+Decodable.swift
//  Bike Compass
//
//  Created by Raúl Riera on 25/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation
import Decodable

enum NSDateDecodingError: ErrorProtocol {
    case invalidStringFormat(String)
}

extension Date {
    static func decode(_ json: AnyObject) throws -> Date {
        let string = try String.decode(json)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(name: "UTC")
        
        guard let date = formatter.date(from: string) else {
            throw NSDateDecodingError.invalidStringFormat(string)
        }
        
        return self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }
}
