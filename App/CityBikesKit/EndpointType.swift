//
//  EndpointType.swift
//  CityBikesKit
//
//  Created by Raul Riera on 2016-04-13.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation

protocol EndpointType {
    associatedtype Response
    
    var baseURL: NSURL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: AnyObject] { get }
    var headers: [String : String] { get }
    var acceptableStatusCodes: Set<Int> { get }
    var encoding: ParameterEncoding { get }
    
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response?
    func errorFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> ErrorType
}

extension EndpointType {
    
    var baseURL: NSURL {
        return NSURL(string: "http://api.citybik.es/v2")!
    }
    
    var parameters: [String: AnyObject] {
        return [:]
    }
    
    var headers: [String: String] {
        return [:]
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var acceptableStatusCodes: Set<Int> {
        return Set(200..<300)
    }
    
    var encoding: ParameterEncoding {
        return .URL
    }
    
    func errorFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> ErrorType {
        return CityBikesKitError.SomethingWentWrong
    }
    
}
