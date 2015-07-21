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
             @"longitude": @"longitude",
             @"address": @"extra.address"
             };
}

- (BOOL)hasBikes
{
    return self.numberOfBikes > 0;
}

- (NSInteger)totalSlots
{
    return self.numberOfBikes + self.emptySlots;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    } else if (![object isKindOfClass:[Station class]]) {
        return NO;
    } else {
        Station *station = object;
        return [self.id isEqualToString:station.id];
    }
}

- (void)setNilValueForKey:(NSString *)key {
    if ([key isEqualToString:@"emptySlots"]) {
        self.emptySlots = 0;
    } else if ([key isEqualToString:@"numberOfBikes"]) {
        self.numberOfBikes = 0;
    } else {
        [super setNilValueForKey:key];
    }
}

@end