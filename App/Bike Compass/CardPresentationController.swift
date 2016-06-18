//
//  CardPresentationController.swift
//  Bike Compass
//
//  Created by Raúl Riera on 02/05/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import UIKit

final class CardPresentationController: UIPresentationController {
    var touchForwardingView: PSPDFTouchForwardingView!
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        let height: CGFloat = 200
        return CGRect(x: 0, y: containerView!.bounds.height - height, width: containerView!.bounds.width, height: height)
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView()?.frame = frameOfPresentedViewInContainerView()
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        touchForwardingView = PSPDFTouchForwardingView(frame: containerView!.bounds)
        touchForwardingView.passthroughViews = [presentingViewController.view];
        containerView?.insertSubview(touchForwardingView, at: 0)
    }
}
