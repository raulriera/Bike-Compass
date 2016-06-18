//
//  ApplicationViewController.swift
//  Bike Compass
//
//  Created by Raúl Riera on 29/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import UIKit
import CoreLocation
import CityBikesKit
import MapKit

class ApplicationViewController: UIViewController {
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var networkButton: UIButton!
    
    var currentNetwork: Network? {
        set {
            assert(newValue != nil, "Never store a nil network")
            Storage<Network>.🔒(newValue!)
        }
        get {
            let value = Storage<Network>.🔓()
            networkButton.setTitle(value?.name ?? "", for: UIControlState())

            return value
        }
        
    }
    var stations: [Station] = [] {
        didSet {
            mapView.removeAnnotations(mapView.annotations)
        }
    }
    let cardTransitioningDelegate = CardTransitioningDelegate()
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldPresentLocationViewController() {
            performSegue(.LocationViewControllerSegue)
        } else if currentNetwork == nil {
            performSegue(.NetworksViewControllerSegue)
        } else {
            loadStations(forNetwork: currentNetwork!)
        }
    }
    
    // MARK:
    
    func loadStations(forNetwork network: Network) {
        CityBikes.stations(forNetwork: network) { response in
            switch response {
            case .success(let stations):
                self.stations = stations
                // Request the current user location
                self.locationManager.requestLocation()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue == .LocationViewControllerSegue, let viewController = segue.destinationViewController.contentViewController as? LocationViewController {
            viewController.delegate = self
        } else if segue == .NetworksViewControllerSegue, let viewController = segue.destinationViewController.contentViewController as? NetworksViewController {
            viewController.delegate = self
            viewController.selectedNetwork = currentNetwork
        } else if segue == .StationsViewControllerSegue, let viewController = segue.destinationViewController.contentViewController as? StationsViewController {
            viewController.stations = stations
            viewController.transitioningDelegate = cardTransitioningDelegate
            viewController.modalPresentationStyle = .custom
            viewController.changeStationHandler = { [weak self] station in
                guard let annotations = self?.mapView.annotations.filter({ ($0.title ?? "") == station.name }) else { return }
                
                self?.mapView.showAnnotations(annotations, animated: true)
            }
        }
    }
    
    // MARK:
    
    func shouldPresentLocationViewController() -> Bool {
        return CLLocationManager.authorizationStatus() != .authorizedWhenInUse
    }
    
    // MARK: Private
    
    @IBAction private func didTapNetworkButton(_ sender: UIButton) {
        presentedViewController?.dismiss(animated: true, completion: {
            self.performSegue(.NetworksViewControllerSegue)
        })
    }
    
}

// MARK: MKMapViewDelegate

extension ApplicationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let annotation = view.annotation as? StationPointAnnotation else { return }
        
        let placemark = MKPlacemark(coordinate: annotation.coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = annotation.station.name
        
        let launchOptions = NSDictionary(object: MKLaunchOptionsDirectionsModeWalking, forKey: MKLaunchOptionsDirectionsModeKey)
        
        let currentLocationMapItem = MKMapItem.forCurrentLocation()
        
        MKMapItem.openMaps(with: [currentLocationMapItem, mapItem], launchOptions: launchOptions as? [String : AnyObject])
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView: MKAnnotationView
        
        if let dequeded = mapView.dequeueReusableAnnotationView(withIdentifier: "mapPin") {
            annotationView = dequeded
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "mapPin")
        }
        
        if let annotation = annotation as? StationPointAnnotation {
            annotationView.canShowCallout = true
            annotationView.image = annotation.station.numberOfBikes > 0 ? UIImage(named: "Marker Positive") : UIImage(named: "Marker Negative")
            
            let walkingIcon = UIImage(named: "Walking Directions Callout")?.withRenderingMode(.alwaysTemplate)
            
            let walkingDirections = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 54))
            walkingDirections.tintColor = .white()
            walkingDirections.backgroundColor = .darkGreenColor()
            walkingDirections.setImage(walkingIcon, for: UIControlState())
            annotationView.leftCalloutAccessoryView = walkingDirections
            return annotationView
        }
        
        return nil
    }
    
}

// MARK: LocationViewControllerDelegate

extension ApplicationViewController: LocationViewControllerDelegate {
    func locationViewController(_ viewController: LocationViewController, didFoundClosestNetwork network: Network, toLocation location: CLLocation) {
        currentNetwork = network
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func locationViewController(_ viewController: LocationViewController, didFailFindingNetworksCloseToLocation location: CLLocation) {
        // Dismiss the LocationViewController and do nothing, our viewDidAppear:
        // will catch that the app is not ready and present a solution by itself
        viewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: NetworksViewControllerDelegate

extension ApplicationViewController: NetworksViewControllerDelegate {
    func networksViewController(_ viewController: NetworksViewController, didSelectedNetwork network: Network, atIndexPath indexPath: IndexPath) {
        
        currentNetwork = network
        viewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: CLLocationManagerDelegate

extension ApplicationViewController: CLLocationManagerDelegate {
    
    @objc(locationManager:didUpdateLocations:) func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Update the stations to show the one closest to the user
        stations = stations.sortByProximityToLocation(location)
        
        let annotations = stations.map {
            return StationPointAnnotation(station: $0)
        }
        
        let mapVisibleRect = MKMapRectForCoordinates([location.coordinate, annotations.first!.coordinate])
        let insets = UIEdgeInsets(top: 0, left: 40, bottom: 200, right: 40)
        mapView.setVisibleMapRect(mapVisibleRect, edgePadding: insets, animated: true)
        mapView.addAnnotations(annotations)
        
        performSegue(.StationsViewControllerSegue)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError) {
        performSegue(.LocationViewControllerSegue)
    }
    
}
