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
@property (strong, nonatomic, nullable) Network *currentNetwork;

/*!
 *	Singletion method
 *
 *	@return returns the instance of this repository
 */
+ (nullable instancetype)sharedRepository;
- (nullable instancetype)init __attribute__((unavailable("init not available. Did you mean sharedRepository?")));

/*!
 *	All the networks available
 *
 *	@param block to execute after the request has finished, containing an array of Network objects if no error ocurred
 */
- (void)networksWithBlock:(nonnull void (^)(NSArray * __nullable, NSError * __nullable))block;
- (void)closestNetworkToLocation:(nonnull CLLocation *)location withBlock:(nonnull void (^)(Network * __nullable, NSError * __nullable))block;
- (void)networkById:(nonnull NSString *)networkId withBlock:(nonnull void (^)(Network * __nullable, NSError * __nullable))block;
- (nullable NSArray *)filterNetworks:(nonnull NSArray *)networks usingKeyword:(nonnull NSString *)keyword;

@end
