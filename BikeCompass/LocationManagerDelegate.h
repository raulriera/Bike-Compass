//
//  LocationManagerDelegate.h
//  BikeCompass
//
//  Created by Raúl Riera on 04/09/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerDelegate <NSObject>

@optional

- (void)locationManager:(CLLocationManager *)locationManager didUpdateLocation:(CLLocation *)location;

@required

- (void)locationManager:(CLLocationManager *)locationManager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;

@end
