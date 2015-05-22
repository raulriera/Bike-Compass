//
//  StationPointAnnotation.m
//  BikeCompass
//
//  Created by Raúl Riera on 31/08/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "StationPointAnnotation.h"

@implementation StationPointAnnotation

- (id)initWithStation:(Station *)station
{

    if ( self = [super init] ) {

        self.coordinate = CLLocationCoordinate2DMake(station.latitude, station.longitude);
        self.title = station.name;
        self.subtitle = [NSString stringWithFormat:NSLocalizedString(@"%ld bikes and %ld spots left", @"Message when the user selects a pin on the map"), station.numberOfBikes.longValue, station.emptySlots.longValue];
        self.station = station;
        
    };
    
    return self;
}

@end
