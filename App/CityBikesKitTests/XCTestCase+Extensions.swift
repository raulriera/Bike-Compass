//
//  XCTestCase+Extensions.swift
//  Bike Compass
//
//  Created by Raúl Riera on 25/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    func loadJSON(_ path: String) -> [String: AnyObject]? {
        guard let path : String = Bundle(for: self.dynamicType).pathForResource(path, ofType: "json"),
            data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
        else {
            return nil
        }
        
        return json
    }
    
}
