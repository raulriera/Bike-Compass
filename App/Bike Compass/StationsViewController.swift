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
                               direction: .forward,
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
                index = stations.index(where: { $0.id == station.id }) else { return 0 }
        
        return index
    }
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
    }
    
    // MARK: Private
    
    private func newStationViewController(_ station: Station) -> StationViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StationViewController") as! StationViewController
        viewController.station = station
        
        return viewController
    }
}

// MARK: UIPageViewControllerDelegate

extension StationsViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard completed else { return }
        changeStationHandler?(currentStation)
    }
}

// MARK: UIPageViewControllerDataSource

extension StationsViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let previousIndex = currentIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard stations.count > previousIndex else {
            return nil
        }
        
        return newStationViewController(stations[previousIndex])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
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
