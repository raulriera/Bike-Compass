//
//  Network.m
//  BikeCompass
//
//  Created by Raúl Riera on 26/08/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "Network.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

@implementation Network

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"id": @"id",
             @"href": @"href",
             @"name": @"name",
             @"location": @"location"
             };
}

+ (NSValueTransformer *)locationJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:Location.class];
}

@end