//
//  BorderView.swift
//  Bike Compass
//
//  Created by Raúl Riera on 08/05/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import UIKit

class BorderView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        applyStyle()
    }
    
    private func applyStyle() {
        layer.borderColor = UIColor.lightGray().cgColor
        layer.borderWidth = 0.5
    }
    
}
