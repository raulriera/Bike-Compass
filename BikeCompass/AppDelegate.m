//
//  AppDelegate.m
//  BikeCompass
//
//  Created by Raúl Riera on 25/08/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "CompassViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Prevent the music from being interrupted
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler
{
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    UIViewController *visibleViewController = [navigationController visibleViewController];
    
    if (![visibleViewController isMemberOfClass:[CompassViewController class]]) {
        [visibleViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    [[navigationController.viewControllers firstObject] restoreUserActivityState:userActivity];
    
    return YES;
}

@end
