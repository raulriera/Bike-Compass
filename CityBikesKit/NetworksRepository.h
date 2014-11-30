//
//  Networks.h
//  BikeCompass
//
//  Created by Raúl Riera on 26/08/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Repository.h"
#import "Network.h"

@interface NetworksRepository : Repository

/*!
 *	The current "active" network
 */
@property (strong, nonatomic) Network *currentNetwork;

+ (instancetype)sharedRepository;
- (instancetype)init __attribute__((unavailable("init not available. Did you mean sharedRepository?")));
- (void)networksWithBlock:(void (^)(NSArray *, NSError *))block;
- (void)closestNetworkToLocation:(CLLocation *)location withBlock:(void (^)(Network *network, NSError *error))block;
- (NSArray *)filterNetworks:(NSArray *)networks usingKeyword:(NSString *)keyword;

@end
