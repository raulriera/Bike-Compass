//
//  LocationManager.h
//  LocationManager
//
//  Created by Raul Riera on 9/3/14. Extending the project https://github.com/madurangae/GeoPointCompass
//  Copyright (c) 2014 Raul Riera. All rights reserved.
//

#import "LocationManager.h"

#define RadiansToDegrees(radians)(radians * 180.0/M_PI)
#define DegreesToRadians(degrees)(degrees * M_PI / 180.0)

@interface LocationManager ()

@property (nonatomic) CGFloat angle;

@end

@implementation LocationManager

- (id) init {
    self = [super init];
    
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        if ([CLLocationManager locationServicesEnabled])
        {
            self.angle = 0;
            
            // Configure and start the LocationManager instance
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            
            [self.locationManager requestWhenInUseAuthorization];
            
            [self.locationManager stopUpdatingLocation];
            [self.locationManager stopUpdatingHeading];
            
            [self.locationManager startUpdatingLocation];
            [self.locationManager startUpdatingHeading];
        }
    }
    return self;
}

// Caculate the angle between the north and the direction to observed geo-location
- (CGFloat)calculateAngle:(CLLocation *)userlocation
{
    CGFloat userLocationLatitude = DegreesToRadians(userlocation.coordinate.latitude);
    CGFloat userLocationLongitude = DegreesToRadians(userlocation.coordinate.longitude);
    
    CGFloat targetedPointLatitude = DegreesToRadians(self.latitudeOfTargetedPoint);
    CGFloat targetedPointLongitude = DegreesToRadians(self.longitudeOfTargetedPoint);
    
    CGFloat longitudeDifference = targetedPointLongitude - userLocationLongitude;
    
    CGFloat y = sin(longitudeDifference) * cos(targetedPointLatitude);
    CGFloat x = cos(userLocationLatitude) * sin(targetedPointLatitude) - sin(userLocationLatitude) * cos(targetedPointLatitude) * cos(longitudeDifference);
    CGFloat radiansValue = atan2(y, x);
    if (radiansValue < 0.0) {
        radiansValue += 2*M_PI;
    }
        
    return radiansValue;
}

# pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Error : %@",[error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{    
    CGFloat direction = newHeading.magneticHeading;
    
    if (direction > 180) {
        direction = 360 - direction;
    } else {
        direction = 0 - direction;
    }
    
    // Rotate the arrow image
    if (self.arrowImageView) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(DegreesToRadians(direction) + self.angle + self.rotationCorrection);
        } completion:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(LocationManagerDelegate)]) {
        [self.delegate locationManager:manager didChangeAuthorizationStatus:status];
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.angle = [self calculateAngle:newLocation];
    self.currentLocation = newLocation;
    
    if ([self.delegate conformsToProtocol:@protocol(LocationManagerDelegate)] && [self.delegate respondsToSelector:@selector(locationManager:didUpdateLocation:)]) {
        [self.delegate locationManager:manager didUpdateLocation:newLocation];
    }
}

#pragma mark - UIRotation


@end
