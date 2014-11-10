//
//  FadeInTransitioning.m
//  BikeCompass
//
//  Created by Raúl Riera on 26/10/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "FadeInTransitioning.h"
#import <POP/POP.h>

@interface FadeInTransitioning ()

@property (nonatomic, getter=isPresenting) BOOL presenting;

@end

@implementation FadeInTransitioning

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    self.presenting = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.presenting = NO;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    
    if (self.isPresenting) {
        fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        fromView.userInteractionEnabled = NO;
        
        UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        
        [transitionContext.containerView addSubview:toView];
        
        scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.2, 1.2)];
        opacityAnimation.fromValue = @(0.9);
        
        [opacityAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        
        [toView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        [toView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    } else {
        toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
        toView.userInteractionEnabled = YES;
                
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.2, 1.2)];
        opacityAnimation.toValue = @(0.0);
        
        [opacityAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        
        [fromView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        [fromView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    }
    
}

@end
