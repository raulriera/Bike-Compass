//
//  UIViewController+Segue.swift
//  Bike Compass
//
//  Created by Raúl Riera on 30/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import UIKit

enum SegueIdentifier: String {
    case LocationViewControllerSegue
    case NetworksViewControllerSegue
    case StationsViewControllerSegue
}

extension UIViewController {
    
    func performSegue(_ identifier: SegueIdentifier) {
        self.performSegue(withIdentifier: identifier.rawValue, sender: self)
    }
    
    // If a navigation controller it will return the first visible view controller, otherwise
    // it will return itself
    public var contentViewController: UIViewController? {
        guard let navigationController = self as? UINavigationController else { return self }
        return navigationController.visibleViewController
    }
}

func ==(lhs: SegueIdentifier, rhs: UIStoryboardSegue) -> Bool {
    return lhs.rawValue == rhs.identifier
}

func ==(lhs: UIStoryboardSegue, rhs: SegueIdentifier) -> Bool {
    return lhs.identifier == rhs.rawValue
}
