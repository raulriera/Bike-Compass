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

/*!
 *	Singletion method
 *
 *	@return returns the instance of this repository
 */
+ (instancetype)sharedRepository;
- (instancetype)init __attribute__((unavailable("init not available. Did you mean sharedRepository?")));

/*!
 *	All the networks available
 *
 *	@param block to execute after the request has finished, containing an array of Network objects if no error ocurred
 */
- (void)networksWithBlock:(void (^)(NSArray *, NSError *))block;
- (void)closestNetworkToLocation:(CLLocation *)location withBlock:(void (^)(Network *network, NSError *error))block;
- (void)networkById:(NSString *)networkId withBlock:(void (^)(Network *network, NSError *))block;
- (NSArray *)filterNetworks:(NSArray *)networks usingKeyword:(NSString *)keyword;

@end
