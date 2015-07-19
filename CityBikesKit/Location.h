//
//  Location.h
//  BikeCompass
//
//  Created by Raúl Riera on 26/08/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import <CoreLocation/CoreLocation.h>

@interface Location : Model

@property (strong, nonatomic, nonnull) NSString *city;
@property (strong, nonatomic, nonnull) NSString *country;
@property (assign, nonatomic) CLLocationDegrees latitude;
@property (assign, nonatomic) CLLocationDegrees longitude;

@end