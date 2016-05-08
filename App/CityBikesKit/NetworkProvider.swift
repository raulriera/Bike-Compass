//
//  NetworkProvider.swift
//  CityBikesKit
//
//  Created by Raul Riera on 2016-04-13.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation

protocol NetworkProvider {
    func request<T: EndpointType>(endpoint: T, handler: (EndpointResponse<T.Response>) -> Void)
}