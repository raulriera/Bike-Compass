//
//  Encodable.swift
//  Bike Compass
//
//  Created by Raúl Riera on 29/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation

public protocol Encodable {
    func encode() -> AnyObject
}