//
//  StationPointAnnotation.h
//  BikeCompass
//
//  Created by Raúl Riera on 31/08/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Station.h"

@interface StationPointAnnotation : MKPointAnnotation

@property (strong, nonatomic) Station *station;

- (id)initWithStation:(Station *)station;

@end
