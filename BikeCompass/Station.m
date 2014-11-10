//
//  Station.m
//  BikeCompass
//
//  Created by Raúl Riera on 26/08/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "Station.h"

@implementation Station

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"id": @"id",
             @"name": @"name",
             @"emptySlots": @"empty_slots",
             @"numberOfBikes": @"free_bikes",
             @"latitude": @"latitude",
             @"longitude": @"longitude"
             };
}

- (BOOL)hasBikes
{
    return self.numberOfBikes > 0;
}

@end