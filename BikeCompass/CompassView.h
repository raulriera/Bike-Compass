//
//  CompassView.h
//  BikeCompass
//
//  Created by Raúl Riera on 11/07/2015.
//  Copyright © 2015 Raúl Riera. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CompassView : UIView

@property (strong, nonatomic, readonly, nonnull) UIImageView *pointerBackgroundImageView;
@property (strong, nonatomic, readonly, nonnull) UIImageView *pointerImageView;

- (void)startPopUpAnimationWithCompletionBlock:(void (^ __nullable)(BOOL))block;
- (void)startPopDownAnimationWithCompletionBlock:(void (^ __nullable)(BOOL))block;

@end
