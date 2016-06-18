//
//  NSDate+Encodable.swift
//  Bike Compass
//
//  Created by Raúl Riera on 29/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation

extension Date: Encodable {
    public func encode() -> AnyObject {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(name: "UTC")
        return formatter.string(from: self)
    }
}
