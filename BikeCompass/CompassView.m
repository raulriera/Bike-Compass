//
//  CompassView.m
//  BikeCompass
//
//  Created by Raúl Riera on 11/07/2015.
//  Copyright © 2015 Raúl Riera. All rights reserved.
//

#import "CompassView.h"

@implementation CompassView

- (nonnull instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }

    return self;
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initViews];
    }
    return self;
}

# pragma mark - Animations

- (void)startPopUpAnimationWithCompletionBlock:(void (^ __nullable)(BOOL))block
{
    self.pointerBackgroundImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.pointerImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.pointerBackgroundImageView.transform = CGAffineTransformIdentity;
        
    } completion:nil];
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.80 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.pointerImageView.transform = CGAffineTransformIdentity;
        
    } completion:block];
}

- (void)startPopDownAnimationWithCompletionBlock:(void (^ __nullable)(BOOL))block
{
    [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:10 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.pointerBackgroundImageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        self.pointerImageView.transform = CGAffineTransformMakeScale(0.95, 0.95);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:10 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            self.pointerBackgroundImageView.transform = CGAffineTransformIdentity;
            self.pointerImageView.transform = CGAffineTransformIdentity;
            
        } completion:block];
        
    }];
}

# pragma mark - Private

- (void)initViews
{
    _pointerBackgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
    _pointerImageView = [[UIImageView alloc] initWithFrame:self.frame];
    
    self.pointerBackgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.pointerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.pointerBackgroundImageView.image = [UIImage imageNamed:@"Wheel"];
    self.pointerImageView.image = [UIImage imageNamed:@"Pointer"];
    
    [self addSubview:self.pointerBackgroundImageView];
    [self addSubview:self.pointerImageView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.pointerBackgroundImageView.widthAnchor constraintEqualToAnchor:self.widthAnchor],
        [self.pointerBackgroundImageView.heightAnchor constraintEqualToAnchor:self.heightAnchor],
        [self.pointerBackgroundImageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.pointerBackgroundImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.pointerImageView.widthAnchor constraintEqualToAnchor:self.widthAnchor],
        [self.pointerImageView.heightAnchor constraintEqualToAnchor:self.heightAnchor],
        [self.pointerImageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.pointerImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
    ]];
    
    self.pointerBackgroundImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.pointerImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
}

@end
