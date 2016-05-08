//
//  SequenceType+Extensions.swift
//  Bike Compass
//
//  Created by Raúl Riera on 28/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation

public extension SequenceType {
    
    /// Categorises elements of self into a dictionary, with the keys given by keyFunc
    public func categorise<U : Hashable>(@noescape keyFunc: Generator.Element -> U) -> [U: [Generator.Element]] {
        var dict: [U: [Generator.Element]] = [:]
        for element in self {
            let key = keyFunc(element)
            if case nil = dict[key]?.append(element) { dict[key] = [element] }
        }
        return dict
    }
}