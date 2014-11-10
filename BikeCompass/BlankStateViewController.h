//
//  BlankStateViewController.h
//  BikeCompass
//
//  Created by Raúl Riera on 24/10/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlankStateViewController : UIViewController

/*!
 *	Use this method to initialize the view controller with the information of your choosing
 *
 *	@param title   heading text
 *	@param message message text
 */
- (void)setTitle:(NSString *)title andMessage:(NSString *)message;

@end
