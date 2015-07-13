//
//  StationsRepository.h
//  BikeCompass
//
//  Created by Raúl Riera on 27/08/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Repository.h"
#import "Network.h"
#import "Station.h"

@interface StationsRepository : Repository

/*!
 *	The current "active" station
 */
@property (strong, nonatomic) Station *currentStation;

/*!
 *	Singletion method
 *
 *	@return returns the instance of this repository
 */
+ (instancetype)sharedRepository;
- (instancetype)init __attribute__((unavailable("init not available. Did you mean sharedRepository?")));

/*!
 *	All the stations for a given network
 *
 *	@param network         Network object to query against
 *	@param completionBlock block to execute after the request has finished
 */
- (void)stationsForNetwork:(Network *)network withCompletionBlock:(void (^)(NSArray *, NSError *))completionBlock;

/*!
 *	Closest station for a given network
 *
 *	@param network         Network object to query against
 *	@param location        Location object
 *	@param completionBlock block to execute after the request has finished
 */
- (void)closestStationForNetwork:(Network *)network toLocation:(CLLocation *)location withCompletionBlock:(void (^)(Station *, NSError *))completionBlock;

/*!
 *	Orders a given array of stations by proximity to a given location and with more than the specified number of bikes
 *
 *	@param stations NSArray of Station objects
 *	@param location CLLocation object
 *	@param bikes    NSInteger of minimun number of bikes
 *
 *	@return NSArray of Station objects
 */
- (NSArray *)sortStations:(NSArray *)stations closestToLocation:(CLLocation *)location withMoreThanBikes:(NSInteger)bikes;

@end
