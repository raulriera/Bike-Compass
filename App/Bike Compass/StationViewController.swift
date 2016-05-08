//
//  StationViewController.swift
//  Bike Compass
//
//  Created by Raúl Riera on 29/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import UIKit
import CityBikesKit

class StationViewController: UIViewController {
    
    @IBOutlet private weak var stationName: UILabel!
    @IBOutlet private weak var stationUpdatedAt: UILabel!
    @IBOutlet private weak var stationAvailability: UIProgressView!
    
    var station: Station?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let station = station else {
            assertionFailure("Station was not set")
            return
        }
        
        stationName.text = station.name
        if let lastUpdated = station.lastUpdated {
           stationUpdatedAt.text = timeAgoSinceDate(lastUpdated)
        } else {
            stationUpdatedAt.text = "n/a"
        }
        stationAvailability.progress = Float(station.numberOfBikes) / Float(station.emptySlots)
    }
    
    override func loadView() {
        super.loadView()
        
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.TopLeft, .TopRight], cornerRadii: CGSize(width: 6, height: 6))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        view.layer.mask = mask
        
        let shape = CAShapeLayer()
        shape.path = mask.path
        shape.fillColor = UIColor.clearColor().CGColor
        shape.strokeColor = UIColor.lightGrayColor().CGColor
        shape.borderWidth = 0.5
        
        view.layer.addSublayer(shape)
        
        //view.layer.cornerRadius = 6
        //view.layer.
    }
}
