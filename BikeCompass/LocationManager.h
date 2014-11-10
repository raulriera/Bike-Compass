//
//  LocationManager.h
//  LocationManager
//
//  Created by Raul Riera on 9/3/14. Extending the project https://github.com/madurangae/GeoPointCompass
//  Copyright (c) 2014 Raul Riera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "LocationManagerDelegate.h"

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic) CLLocationDegrees latitudeOfTargetedPoint;
@property (nonatomic) CLLocationDegrees longitudeOfTargetedPoint;
@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, assign) id <LocationManagerDelegate> delegate;

@end
