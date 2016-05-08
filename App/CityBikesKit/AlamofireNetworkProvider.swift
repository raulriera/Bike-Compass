//
//  AlamofireNetworkProvider.swift
//  CityBikesKit
//
//  Created by Raul Riera on 2016-04-13.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation
import Alamofire

public enum CityBikesKitError: ErrorType {
    case NoHTTPResponse
    case InvalidResponse
    case SomethingWentWrong
}

struct AlamofireNetworkProvider: NetworkProvider {
    func request<T: EndpointType>(endpoint: T, handler: (EndpointResponse<T.Response>) -> Void) {
        
        let method = httpMethod(endpoint.method)
        let absoluteURL = endpoint.baseURL.absoluteString.stringByAppendingString(endpoint.path)
        let encoding = parameterEncoding(endpoint.encoding)
        
        Alamofire.request(method, absoluteURL, parameters: endpoint.parameters, encoding: encoding, headers: endpoint.headers)
            .validate(statusCode: endpoint.acceptableStatusCodes)
            .responseJSON { response in
                
                guard let URLResponse = response.response else {
                    handler(EndpointResponse.Failure(CityBikesKitError.NoHTTPResponse))
                    return
                }
                
                switch response.result {
                case .Success(let value):
                    if let success = endpoint.responseFromObject(value, URLResponse: URLResponse) {
                        handler(EndpointResponse.Success(success))
                    } else {
                        handler(EndpointResponse.Failure(CityBikesKitError.InvalidResponse))
                    }
                    
                case .Failure(_):
                    let failure = endpoint.errorFromObject(response.data ?? NSData(), URLResponse: URLResponse)
                    handler(EndpointResponse.Failure(failure))
                }
                
        }
    }
    
    // MARK:
    
    private func httpMethod(method: HTTPMethod) -> Alamofire.Method {
        return Alamofire.Method(rawValue: method.rawValue)!
    }
    
    private func parameterEncoding(encoding: ParameterEncoding) -> Alamofire.ParameterEncoding {
        switch encoding {
        case .URL:
            return Alamofire.ParameterEncoding.URL
        case .JSON:
            return Alamofire.ParameterEncoding.JSON
        }
    }
    
}
