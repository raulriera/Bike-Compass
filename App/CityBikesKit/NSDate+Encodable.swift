//
//  NSDate+Encodable.swift
//  Bike Compass
//
//  Created by Raúl Riera on 29/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation

extension NSDate: Encodable {
    public func encode() -> AnyObject {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = NSTimeZone(name: "UTC")
        return formatter.stringFromDate(self)
    }
}