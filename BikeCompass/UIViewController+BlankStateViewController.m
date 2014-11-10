//
//  UIViewController+BlankStateViewController.m
//  BikeCompass
//
//  Created by Raúl Riera on 26/10/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "UIViewController+BlankStateViewController.h"

@implementation UIViewController (BlankStateViewController)

- (void)overlayBlankStateView:(BlankStateViewControllerType)viewType withTitle:(NSString *)title message:(NSString *)message
{
    BlankStateViewController* blankStateViewController = [[UIStoryboard storyboardWithName:@"BlankState" bundle:nil] instantiateViewControllerWithIdentifier:[self viewControllerIdentifierFromType:viewType]];
    
    [blankStateViewController setTitle:title andMessage:message];
    
    UIView *overlayView = blankStateViewController.view;
    overlayView.tag = [self viewTag];
    
    [self.view addSubview:overlayView];    
}

- (void)overlayBlankStateViewWithTitle:(NSString *)title message:(NSString *)message
{
    [self overlayBlankStateView:BlankStateViewControllerTypeDefault withTitle:title message:message];
}

- (void)removeBlankStateViewOverlay
{
    UIView *overlayView = [self.view viewWithTag:[self viewTag]];
    [overlayView removeFromSuperview];
}

- (BOOL)isBlankStateViewOverlayPresent
{
    return [self.view viewWithTag:[self viewTag]] != nil;
}

- (NSInteger)viewTag
{
    return 454567;
}

- (NSString *)viewControllerIdentifierFromType:(BlankStateViewControllerType)type
{
    NSString *viewControllerIdentifier;
    
    switch (type) {
        case BlankStateViewControllerTypeDefault:
            viewControllerIdentifier = @"BlankStateViewControllerDefault";
            break;
            
        default:
            break;
    }
    
    return viewControllerIdentifier;
}

@end
