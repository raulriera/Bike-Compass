//
//  CityDetectionUIViewController.m
//  BikeCompass
//
//  Created by Raúl Riera on 28/10/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "CityDetectionViewController.h"
#import "LocationManager.h"
#import "UIViewController+BlankStateViewController.h"
#import "NetworksRepository.h"

@interface CityDetectionViewController () <LocationManagerDelegate>

@property (strong, nonatomic) LocationManager *locationManager;

@end

@implementation CityDetectionViewController

#pragma mark - LocationManagerDelegate

- (void)locationManager:(CLLocationManager *)locationManager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse
        || status == kCLAuthorizationStatusAuthorizedAlways) {
        
        if (self.isBlankStateViewOverlayPresent) {
            [self removeBlankStateViewOverlay];
        }
                
    } else if (status == kCLAuthorizationStatusDenied) {
        [self overlayBlankStateViewWithTitle:NSLocalizedString(@"Location Services are disabled", @"Generic title when the localisation is disabled") message:NSLocalizedString(@"Please enable location services in your device 'Settings' screen", @"Instructions on how to enable location services")];
    }
}

- (void)locationManager:(CLLocationManager *)locationManager didUpdateLocation:(CLLocation *)location
{    
    [[NetworksRepository sharedRepository] closestNetworkToLocation:location withBlock:^(Network *network, NSError *error) {
        
        if (self.delegate) {
            [self.delegate viewController:self didChooseNetwork:network];
        }
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];

    }];
}

#pragma mark - Actions

- (IBAction)useLocationTapped:(UIButton *)sender
{
    [self requestLocationServices];
}

#pragma mark -

- (void)requestLocationServices
{
    // Prepare to init the compass
    self.locationManager = [[LocationManager alloc] init];
    
    // Makes us the delegate
    self.locationManager.delegate = self;
}

#pragma mark - NSUserActivity

- (void)restoreUserActivityState:(nonnull NSUserActivity *)activity
{
    [self requestLocationServices];
}

@end
