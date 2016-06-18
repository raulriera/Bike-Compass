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
    case success(T)
    case failure(ErrorProtocol)
}

public class CityBikes {
    static let service = NetworkService()
    
    // MARK: Networks
    
    public class func networkClosestToLocation(_ location: CLLocation, completionHandler: (Response<Network>) -> Void) {
        networks { response in
            switch response {
            case .success(let networks):
                let network = networks.sortByProximityToLocation(location).first!
                completionHandler(.success(network))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
    }
    
    public class func networks(_ completionHandler: (Response<[Network]>) -> Void) {
        service.request(NetworksEndpoint()) { response in
            switch response {
            case .success(let networks):
                completionHandler(.success(networks))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    // MARK: Stations
    
    public class func stations(forNetwork network: Network, completionHandler: (Response<[Station]>) -> Void) {
        let stationsEndpoint = StationsEndpoint(networkId: network.id)
        service.request(stationsEndpoint) { response in
            switch response {
            case .success(let stations):
                completionHandler(.success(stations))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
}
