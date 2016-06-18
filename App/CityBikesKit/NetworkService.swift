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
    case url
    case json
}

enum EndpointResponse<T> {
    case success(T)
    case failure(ErrorProtocol)
}

class NetworkService {
    let provider: NetworkProvider
    
    init(provider: NetworkProvider = AlamofireNetworkProvider()) {
        self.provider = provider
    }
    
    func request<T: EndpointType>(_ endpoint: T, handler: (EndpointResponse<T.Response>) -> Void) {
        provider.request(endpoint, handler: handler)
    }
}

