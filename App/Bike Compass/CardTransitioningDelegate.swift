//
//  CardTransitioningDelegate.swift
//  Bike Compass
//
//  Created by Raúl Riera on 03/05/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import UIKit

class CardTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController,
                                                          presentingViewController presenting: UIViewController,
                                                                                   sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return CardPresentationController(presentedViewController: presented,
                                          presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardPresentationAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardDismissionAnimator()
    }
}