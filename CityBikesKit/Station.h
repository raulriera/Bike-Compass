//
//  Station.h
//  BikeCompass
//
//  Created by Raúl Riera on 26/08/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import <CoreLocation/CoreLocation.h>

@interface Station : Model

@property (strong, nonatomic, nonnull) NSString *id;
@property (strong, nonatomic, nonnull) NSString *name;
@property (assign, nonatomic) NSInteger emptySlots;
@property (assign, nonatomic) NSInteger numberOfBikes;
@property (assign, nonatomic, readonly) NSInteger totalSlots;
@property (assign, nonatomic) CLLocationDegrees latitude;
@property (assign, nonatomic) CLLocationDegrees longitude;
@property (strong, nonatomic, nonnull) NSString *address;
@property (assign, nonatomic, readonly) BOOL hasBikes;
@end
