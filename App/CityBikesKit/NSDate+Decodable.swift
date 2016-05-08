//
//  NSDate+Decodable.swift
//  Bike Compass
//
//  Created by Raúl Riera on 25/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation
import Decodable

enum NSDateDecodingError: ErrorType {
    case InvalidStringFormat(String)
}

extension NSDate {
    class func decode(json: AnyObject) throws -> Self {
        let string = try String.decode(json)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = NSTimeZone(name: "UTC")
        
        guard let date = formatter.dateFromString(string) else {
            throw NSDateDecodingError.InvalidStringFormat(string)
        }
        
        return self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }
}