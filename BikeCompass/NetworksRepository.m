//
//  Networks.m
//  BikeCompass
//
//  Created by Raúl Riera on 26/08/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "NetworksRepository.h"
#import <AFNetworking.h>
#import <MTLJSONAdapter.h>

@implementation NetworksRepository

static NSString * const CurrentNetworkKey = @"com.raulriera.bikecompass.currentNetwork";

+ (instancetype)sharedRepository
{
    static NetworksRepository *sharedRepository = nil;
    if (sharedRepository == nil)
    {
        sharedRepository = [[self alloc] init];
    }
    return sharedRepository;
}

- (Network *)currentNetwork
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentNetworkKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)closestNetworkToLocation:(CLLocation *)location withBlock:(void (^)(Network *network, NSError *error))block
{
    [self networksWithBlock:^(NSArray *networks, NSError *error) {
        Network *network = [[self sortNetworks:networks closestToLocation:location] firstObject];
        block(network, error);
    }];
}

- (void)setCurrentNetwork:(Network *)currentNetwork
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentNetwork];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:CurrentNetworkKey];
}

- (void)networksWithBlock:(void (^)(NSArray *networks, NSError *error))block
{
    NSString *url = [RepositoryBaseURL stringByAppendingString:@"/v2/networks?fields=id,name,href,location"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        NSArray *data = [MTLJSONAdapter modelsOfClass:[Network class] fromJSONArray:[responseObject valueForKey:@"networks"] error:&error];
        if (error) {
            block(nil, error);
        }
        
        data = [self sortNetworksAlphabetically:data];
        
        block(data, error);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
    
}

- (NSArray *)sortNetworks:(NSArray *)networks closestToLocation:(CLLocation *)location
{
    
    networks = [networks sortedArrayUsingComparator: ^(Network *a, Network *b) {
        
        CLLocation *aLocation = [[CLLocation alloc] initWithLatitude:a.location.latitude longitude:a.location.longitude];
        CLLocation *bLocation = [[CLLocation alloc] initWithLatitude:b.location.latitude longitude:b.location.longitude];
        
        CLLocationDistance aDistance = [aLocation distanceFromLocation:location];
        CLLocationDistance bDistance = [bLocation distanceFromLocation:location];
        if ( aDistance < bDistance ) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if ( aDistance > bDistance) {
            return (NSComparisonResult)NSOrderedDescending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    return networks;
}

- (NSArray *)sortNetworksAlphabetically:(NSArray *)networks
{
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"location.country" ascending:YES];
    networks = [networks sortedArrayUsingDescriptors:@[sort]];
    
    return networks;
}

- (NSArray *)filterNetworks:(NSArray *)networks usingKeyword:(NSString *)keyword
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@ OR location.city contains[c] %@ OR location.country contains[c] %@", keyword, keyword, keyword];
    return [networks filteredArrayUsingPredicate:predicate];
}

@end
