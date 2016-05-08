//
//  PSPDFTouchForwardingView.swift
//  Bike Compass
//
//  Created by Raúl Riera on 03/05/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import UIKit

// This class allows the "presentedController" to receive touches
// https://pspdfkit.com/blog/2015/presentation-controllers/
final class PSPDFTouchForwardingView: UIView {
    
    final var passthroughViews: [UIView] = []
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, withEvent: event) else { return nil }
        guard hitView == self else { return hitView }
        
        for passthroughView in passthroughViews {
            let point = convertPoint(point, toView: passthroughView)
            if let passthroughHitView = passthroughView.hitTest(point, withEvent: event) {
                return passthroughHitView
            }
        }
        
        return self
    }
}
