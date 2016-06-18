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
    
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: AnyObject] { get }
    var headers: [String : String] { get }
    var acceptableStatusCodes: Set<Int> { get }
    var encoding: ParameterEncoding { get }
    
    func responseFrom(_ object: AnyObject, URLResponse: HTTPURLResponse) -> Response?
    func errorFrom(_ object: AnyObject, URLResponse: HTTPURLResponse) -> ErrorProtocol
}

extension EndpointType {
    
    var baseURL: URL {
        return URL(string: "http://api.citybik.es/v2")!
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
        return .url
    }
    
    func errorFrom(_ object: AnyObject, URLResponse: HTTPURLResponse) -> ErrorProtocol {
        return CityBikesKitError.somethingWentWrong
    }
    
}
