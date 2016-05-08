//
//  CardPresentationAnimator.swift
//  Bike Compass
//
//  Created by Raúl Riera on 07/05/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import UIKit

class CardPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()
        
        let animationDuration = transitionDuration(transitionContext)
        
        toViewController.view.transform = CGAffineTransformMakeTranslation(containerView!.bounds.width, 0)
        toViewController.view.layer.shadowColor = UIColor.blackColor().CGColor
        toViewController.view.layer.shadowOffset = CGSizeMake(0.0, 2.0)
        toViewController.view.layer.shadowOpacity = 0.3
        toViewController.view.layer.cornerRadius = 4.0
        toViewController.view.clipsToBounds = true
        
        containerView!.addSubview(toViewController.view)
                
        UIView.animateWithDuration(animationDuration, animations: {
            toViewController.view.transform = CGAffineTransformIdentity
            }, completion: { finished in
                transitionContext.completeTransition(finished)
        })

    }
}