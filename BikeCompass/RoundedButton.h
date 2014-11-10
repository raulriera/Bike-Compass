//
//  RoundedButton.h
//  BikeCompass
//
//  Created by Raúl Riera on 30/10/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundedButton : UIButton

@property (nonatomic) IBInspectable NSInteger cornerRadius;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable NSInteger borderWidth;

@end
