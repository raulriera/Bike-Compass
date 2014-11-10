//
//  LocationDisabledViewController.m
//  BikeCompass
//
//  Created by Raúl Riera on 12/10/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "LocationDisabledViewController.h"
#import "LocationManager.h"

@implementation LocationDisabledViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)applicationWillEnterForeground
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];

    if (status == kCLAuthorizationStatusAuthorizedWhenInUse
        || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
