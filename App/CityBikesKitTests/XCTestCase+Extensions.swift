//
//  XCTestCase+Extensions.swift
//  Bike Compass
//
//  Created by Raúl Riera on 25/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    func loadJSON(path: String) -> [String: AnyObject]? {
        guard let path : String = NSBundle(forClass: self.dynamicType).pathForResource(path, ofType: "json"),
            data = NSData(contentsOfFile: path),
            json = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject]
        else {
            return nil
        }
        
        return json
    }
    
}