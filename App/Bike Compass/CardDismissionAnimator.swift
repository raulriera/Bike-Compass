//
//  CardDismissionAnimator.swift
//  Bike Compass
//
//  Created by Raúl Riera on 07/05/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import UIKit

class CardDismissionAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let containerView = transitionContext.containerView()
        
        let animationDuration = transitionDuration(transitionContext)
        
        UIView.animateWithDuration(animationDuration, animations: {
            fromViewController.view.transform = CGAffineTransformMakeTranslation(containerView!.bounds.width, 0)
        }) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}
