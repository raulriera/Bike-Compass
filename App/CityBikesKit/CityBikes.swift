//
//  CityBikes.swift
//  Bike Compass
//
//  Created by Raúl Riera on 23/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

public enum Response<T> {
    case Success(T)
    case Failure(ErrorType)
}

public class CityBikes {
    static let service = NetworkService()
    
    // MARK: Networks
    
    public class func networkClosestToLocation(location: CLLocation, completionHandler: (Response<Network>) -> Void) {
        networks { response in
            switch response {
            case .Success(let networks):
                let network = networks.sortByProximityToLocation(location).first!
                completionHandler(.Success(network))
            case .Failure(let error):
                completionHandler(.Failure(error))
            }
        }
        
    }
    
    public class func networks(completionHandler: (Response<[Network]>) -> Void) {
        service.request(NetworksEndpoint()) { response in
            switch response {
            case .Success(let networks):
                completionHandler(.Success(networks))
            case .Failure(let error):
                completionHandler(.Failure(error))
            }
        }
    }
    
    // MARK: Stations
    
    public class func stations(forNetwork network: Network, completionHandler: (Response<[Station]>) -> Void) {
        let stationsEndpoint = StationsEndpoint(networkId: network.id)
        service.request(stationsEndpoint) { response in
            switch response {
            case .Success(let stations):
                completionHandler(.Success(stations))
            case .Failure(let error):
                completionHandler(.Failure(error))
            }
        }
    }
    
}