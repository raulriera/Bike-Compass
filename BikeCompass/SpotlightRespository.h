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

@interface SpotlightRespository : NSObject

+ (void)indexStations:(NSArray *)stations andNetwork:(Network *)network;

@end
