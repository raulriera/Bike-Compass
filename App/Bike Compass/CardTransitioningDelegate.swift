//
//  CardTransitioningDelegate.swift
//  Bike Compass
//
//  Created by Raúl Riera on 03/05/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import UIKit

class CardTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresentedViewController presented: UIViewController,
                                                          presenting: UIViewController?,
                                                                                   sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return CardPresentationController(presentedViewController: presented,
                                          presenting: presenting)
    }
    
    func animationController(forPresentedController presented: UIViewController, presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardPresentationAnimator()
    }
    
    func animationController(forDismissedController dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardDismissionAnimator()
    }
}
