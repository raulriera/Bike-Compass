//
//  RootNavigationController.m
//  BikeCompass
//
//  Created by Raúl Riera on 28/06/2015.
//  Copyright © 2015 Raúl Riera. All rights reserved.
//

#import "RootNavigationController.h"

@implementation RootNavigationController

- (void)restoreUserActivityState:(nonnull NSUserActivity *)activity
{    
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * __nonnull viewController, NSUInteger index, BOOL * __nonnull stop) {
        
        [viewController restoreUserActivityState:activity];
    }];
    
    [super restoreUserActivityState:activity];
}

@end
