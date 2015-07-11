//
//  SpotlightRespository.h
//  BikeCompass
//
//  Created by Raúl Riera on 27/06/2015.
//  Copyright © 2015 Raúl Riera. All rights reserved.
//

@import Foundation;
#import "Station.h"
#import "Network.h"

typedef enum : NSUInteger {
    SpotlightIndexStatusIndexed,
    SpotlightIndexStatusMissing
} SpotlightIndexStatus;

@interface SpotlightRespository : NSObject

+ (void)indexStations:(NSArray *)stations andNetwork:(Network *)network;
+ (SpotlightIndexStatus)indexStatusForNetwork:(Network *)network;

@end
