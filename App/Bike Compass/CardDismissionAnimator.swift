//
//  CardDismissionAnimator.swift
//  Bike Compass
//
//  Created by Raúl Riera on 07/05/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import UIKit

class CardDismissionAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(_ transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextFromViewControllerKey)!
        let containerView = transitionContext.containerView()
        
        let animationDuration = transitionDuration(transitionContext)
        
        UIView.animate(withDuration: animationDuration, animations: {
            fromViewController.view.transform = CGAffineTransform(translationX: containerView.bounds.width, y: 0)
        }) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}
