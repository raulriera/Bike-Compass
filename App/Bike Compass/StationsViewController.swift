//
//  StationsViewController.swift
//  Bike Compass
//
//  Created by Raúl Riera on 02/05/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import UIKit
import CityBikesKit

class StationsViewController: UIPageViewController {
    typealias ChangeStationHandler = (Station)->()
    
    var stations: [Station] = [] {
        didSet {
            guard stations.isNotEmpty else { return }
            let viewController = newStationViewController(stations.first!)
            setViewControllers([viewController],
                               direction: .Forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    var currentStation: Station {
        return stations[currentIndex]
    }
    
    var changeStationHandler: ChangeStationHandler?
    
    private var currentIndex: Int {
        guard let visibleViewController = viewControllers?.first as? StationViewController,
                station = visibleViewController.station,
                index = stations.indexOf({ $0.id == station.id }) else { return 0 }
        
        return index
    }
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
    }
    
    // MARK: Private
    
    private func newStationViewController(station: Station) -> StationViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StationViewController") as! StationViewController
        viewController.station = station
        
        return viewController
    }
}

// MARK: UIPageViewControllerDelegate

extension StationsViewController: UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard completed else { return }
        changeStationHandler?(currentStation)
    }
}

// MARK: UIPageViewControllerDataSource

extension StationsViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let previousIndex = currentIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard stations.count > previousIndex else {
            return nil
        }
        
        return newStationViewController(stations[previousIndex])
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let nextIndex = currentIndex + 1
        let stationsCount = stations.count
        
        guard stationsCount != nextIndex else {
            return nil
        }
        
        guard stationsCount > nextIndex else {
            return nil
        }
        
        return newStationViewController(stations[nextIndex])
    }
    
}
