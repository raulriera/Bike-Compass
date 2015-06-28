//
//  AppDelegate.m
//  BikeCompass
//
//  Created by Raúl Riera on 25/08/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

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
    
    return YES;
}

@end
