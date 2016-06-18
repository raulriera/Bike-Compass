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
    
    class func 🔒(_ value: T) {
        vault().set(value.encode(), forKey: "\(T.self)")
    }
    
    class func 🔓() -> T? {
        guard let val = vault().object(forKey: "\(T.self)") else { return nil }
        return try? T.decode(val)
    }
    
    class func 💀() {
        vault().removeObject(forKey: "\(T.self)")
    }
    
    // MARK: Private
    
    private class func vault() -> UserDefaults {
        return UserDefaults.standard()
    }
}
