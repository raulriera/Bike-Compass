//
//  LocationViewController.swift
//  Bike Compass
//
//  Created by Raúl Riera on 23/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import UIKit
import CoreLocation
import CityBikesKit

protocol LocationViewControllerDelegate: class {
    func locationViewController(viewController: LocationViewController, didFoundClosestNetwork network: Network, toLocation location: CLLocation)
    func locationViewController(viewController: LocationViewController, didFailFindingNetworksCloseToLocation location: CLLocation)
}

class LocationViewController: UIViewController {
    
    @IBOutlet weak var rippleLarge: UIImageView!
    @IBOutlet weak var rippleMedium: UIImageView!
    @IBOutlet weak var rippleSmall: UIImageView!
    @IBOutlet weak var walkingIcon: UIImageView!
    
    weak var delegate: LocationViewControllerDelegate?
    private let locationManager = CLLocationManager()
    private var isAnimationRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        // Prepare and run all animations
        animateViews()
    }
    
    // MARK: IB Actions
    
    @IBAction func didTapLocateMeButton(sender: UIButton) {
        // Check that the ripples aren't animating before trying
        // to run the animation loop
        if isAnimationRunning == false {
            animateRipples()
        }
        
        switch CLLocationManager.authorizationStatus() {
            
        case .AuthorizedWhenInUse, .NotDetermined, .AuthorizedAlways:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        case .Denied, .Restricted:
            presentViewController(locationAuthorizationErrorViewController(), animated: true, completion: nil)
        }
    }

}

extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            manager.requestLocation()
        } else if status == .Denied {
            presentViewController(locationAuthorizationErrorViewController(), animated: true, completion: nil)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        CityBikes.networkClosestToLocation(location) { response in
            switch response {
            case .Success(let network):
                self.delegate?.locationViewController(self, didFoundClosestNetwork: network, toLocation: location)
            case .Failure(_):
                self.delegate?.locationViewController(self, didFailFindingNetworksCloseToLocation: location)
            }
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // Present the network picker instead of displaying an error to the user
    }
    
    // MARK: 
    
    private func locationAuthorizationErrorViewController() -> UIAlertController {
        let errorController = UIAlertController(title: "Missing permission", message: "Your location is required for this application to work. Don't worry, we are gently with the battery", preferredStyle: .Alert)
        errorController.addAction(UIAlertAction(title: "Go to settings", style: .Default, handler: { action in
            errorController.dismissViewControllerAnimated(true, completion: nil)
         
            let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString)!
            UIApplication.sharedApplication().openURL(settingsURL)
        }))
        
        return errorController
    }
}

private extension LocationViewController {
    
    private func animateViews() {
        prepareViewsForAnimations()
        
        UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.8, options: .BeginFromCurrentState, animations: {
            
            self.walkingIcon.alpha = 1
            self.walkingIcon.transform = CGAffineTransformIdentity
            
            }, completion: nil)
    }
    
    private func prepareViewsForAnimations() {
        walkingIcon.alpha = 0
        walkingIcon.transform = CGAffineTransformMakeScale(0.2, 0.2)
        
        prepareRipplesForAnimations()
    }
    
    private func prepareRipplesForAnimations() {
        rippleLarge.alpha = 0
        rippleMedium.alpha = 0
        rippleSmall.alpha = 0
        
        rippleLarge.transform = CGAffineTransformMakeScale(0.7, 0.7)
        rippleMedium.transform = CGAffineTransformMakeScale(0.7, 0.7)
        rippleSmall.transform = CGAffineTransformMakeScale(0.7, 0.7)
    }
    
    private func animateRipples() {
        isAnimationRunning = true
        prepareRipplesForAnimations()
        
        fadeInRipple(rippleSmall)
        fadeInRipple(rippleMedium, delay: 0.2)
        fadeInRipple(rippleLarge, delay: 0.4) { _ in
            // Reverse the animations
            self.fadeOutRipple(self.rippleSmall)
            self.fadeOutRipple(self.rippleMedium, delay: 0.2)
            self.fadeOutRipple(self.rippleLarge, delay: 0.4) { _ in
                self.animateRipples()
            }
        }
    }
    
    private func fadeInRipple(rippleView: UIImageView, delay: NSTimeInterval = 0, completionHandler: (Bool->Void)? = nil) {
        UIView.animateWithDuration(0.4, delay: delay, options: .BeginFromCurrentState, animations: {
            rippleView.alpha = 1
            rippleView.transform = CGAffineTransformMakeScale(0.8, 0.8)
            
            }, completion: completionHandler)
    }
    
    private func fadeOutRipple(rippleView: UIImageView, delay: NSTimeInterval = 0, completionHandler: (Bool->Void)? = nil) {
        UIView.animateWithDuration(0.4, delay: delay, options: .BeginFromCurrentState, animations: {
            rippleView.alpha = 0
            rippleView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            
            }, completion: completionHandler)
    }

}

