//
//  Location.m
//  BikeCompass
//
//  Created by Raúl Riera on 26/08/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "Location.h"

@implementation Location

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"city" : @"city",
             @"country" : @"country",
             @"latitude": @"latitude",
             @"longitude": @"longitude"
             };
}

- (NSString *)country
{
    return [[NSLocale systemLocale] displayNameForKey:NSLocaleCountryCode value:_country];
}

@end