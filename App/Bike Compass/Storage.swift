//
//  Storage.swift
//  Bike Compass
//
//  Created by Raúl Riera on 01/05/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation
import CityBikesKit
import Decodable

class Storage<T where T: Decodable, T: Encodable> {
    
    private init() { }
    
    class func 🔒(value: T) {
        vault().setObject(value.encode(), forKey: "\(T.self)")
    }
    
    class func 🔓() -> T? {
        guard let val = vault().objectForKey("\(T.self)") else { return nil }
        return try? T.decode(val)
    }
    
    class func 💀() {
        vault().removeObjectForKey("\(T.self)")
    }
    
    // MARK: Private
    
    private class func vault() -> NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
}
