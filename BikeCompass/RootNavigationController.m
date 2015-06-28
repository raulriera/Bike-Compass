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
    UIViewController *visibleViewController = self.visibleViewController;
    [visibleViewController restoreUserActivityState:activity];
}

@end
