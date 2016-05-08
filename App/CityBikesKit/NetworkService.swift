//
//  NetworkService.swift
//  CityBikesKit
//
//  Created by Raul Riera on 2016-04-13.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PATCH
}

enum ParameterEncoding {
    case URL
    case JSON
}

enum EndpointResponse<T> {
    case Success(T)
    case Failure(ErrorType)
}

class NetworkService {
    let provider: NetworkProvider
    
    init(provider: NetworkProvider = AlamofireNetworkProvider()) {
        self.provider = provider
    }
    
    func request<T: EndpointType>(endpoint: T, handler: (EndpointResponse<T.Response>) -> Void) {
        provider.request(endpoint, handler: handler)
    }
}

