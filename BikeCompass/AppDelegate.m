//
//  AppDelegate.m
//  BikeCompass
//
//  Created by Raúl Riera on 25/08/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
@import CoreSpotlight;

@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Prevent the music to be interrupted
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler
{
    
    [self.window.rootViewController restoreUserActivityState:userActivity];
    
//    if ([userActivity.activityType isEqualToString:@"com.raulriera.dublinbikes.handoff"]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName: @"didContinueFromWatch" object:nil userInfo:userActivity.userInfo];
//
//    } else if ([[userActivity activityType] isEqualToString:CSSearchableItemActionType]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName: @"didContinueFromSearch" object:nil userInfo:userActivity.userInfo];
//    }
    
    return NO;
}

@end
