//
//  UIViewController+BlankStateViewController.h
//  BikeCompass
//
//  Created by Raúl Riera on 26/10/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlankStateViewController.h"

typedef enum : NSUInteger {
    BlankStateViewControllerTypeDefault
} BlankStateViewControllerType;

@interface UIViewController (BlankStateViewController)

/*!
 *	Use this method to present the default type of 'Blank State View'
 *
 *	@param title   text to display
 *	@param message text to display
 */
- (void)overlayBlankStateViewWithTitle:(NSString *)title message:(NSString *)message;

/*!
 *	Use this method to remove any 'Blank State View' that overlays present in the view stack
 */
- (void)removeBlankStateViewOverlay;

/*!
 *	Use this method if you wish to check if the 'Blank State View' is present in the current stack
 *
 *	@return YES if the view is present in the view stack
 */
- (BOOL)isBlankStateViewOverlayPresent;

@end
