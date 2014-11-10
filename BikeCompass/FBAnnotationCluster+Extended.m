//
//  FBAnnotationCluster+Extended.m
//  BikeCompass
//
//  Created by Raúl Riera on 21/09/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "FBAnnotationCluster+Extended.h"

@implementation FBAnnotationCluster (Extended)

#define kSmallValue 1e-5

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    } else if (![object isKindOfClass:[FBAnnotationCluster class]]) {
        return NO;
    } else {
        FBAnnotationCluster *cluster = object;
        return self.annotations.count == cluster.annotations.count && ABS(self.coordinate.latitude - cluster.coordinate.latitude) < kSmallValue && ABS(self.coordinate.longitude - cluster.coordinate.longitude) < kSmallValue;
    }
}

- (NSUInteger)hash
{
    return self.coordinate.latitude + self.coordinate.longitude;
}

@end
