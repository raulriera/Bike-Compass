//
//  AlamofireNetworkProvider.swift
//  CityBikesKit
//
//  Created by Raul Riera on 2016-04-13.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation
import Alamofire

public enum CityBikesKitError: ErrorProtocol {
    case nohttpResponse
    case invalidResponse
    case somethingWentWrong
}

struct AlamofireNetworkProvider: NetworkProvider {
    func request<T: EndpointType>(_ endpoint: T, handler: (EndpointResponse<T.Response>) -> Void) {
        
        let method = httpMethod(endpoint.method)
        let absoluteURL = endpoint.baseURL.absoluteString! + endpoint.path
        let encoding = parameterEncoding(endpoint.encoding)
        
        Alamofire.request(method, absoluteURL, parameters: endpoint.parameters, encoding: encoding, headers: endpoint.headers)
            .validate(statusCode: endpoint.acceptableStatusCodes)
            .responseJSON { response in
                
                guard let URLResponse = response.response else {
                    handler(EndpointResponse.failure(CityBikesKitError.nohttpResponse))
                    return
                }
                
                switch response.result {
                case .success(let value):
                    if let success = endpoint.responseFrom(value, URLResponse: URLResponse) {
                        handler(EndpointResponse.success(success))
                    } else {
                        handler(EndpointResponse.failure(CityBikesKitError.invalidResponse))
                    }
                    
                case .failure(_):
                    let failure = endpoint.errorFrom(response.data ?? Data(), URLResponse: URLResponse)
                    handler(EndpointResponse.failure(failure))
                }
                
        }
    }
    
    // MARK:
    
    private func httpMethod(_ method: HTTPMethod) -> Alamofire.Method {
        return Alamofire.Method(rawValue: method.rawValue)!
    }
    
    private func parameterEncoding(_ encoding: ParameterEncoding) -> Alamofire.ParameterEncoding {
        switch encoding {
        case .url:
            return Alamofire.ParameterEncoding.url
        case .json:
            return Alamofire.ParameterEncoding.json
        }
    }
    
}
