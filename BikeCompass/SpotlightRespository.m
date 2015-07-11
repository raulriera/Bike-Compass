//
//  SpotlightRespository.m
//  BikeCompass
//
//  Created by Raúl Riera on 27/06/2015.
//  Copyright © 2015 Raúl Riera. All rights reserved.
//

#import "SpotlightRespository.h"
#import "Repository.h"
@import CoreSpotlight;
@import MobileCoreServices;

@implementation SpotlightRespository

+ (void)indexStations:(NSArray *)stations andNetwork:(Network *)network
{
    NSMutableArray *items = [[NSMutableArray alloc] init];

    [stations enumerateObjectsUsingBlock:^(Station *station, NSUInteger index, BOOL * __nonnull stop) {

        CSSearchableItemAttributeSet* attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeText];

        attributeSet.title = network.name;
        attributeSet.contentDescription = [NSString stringWithFormat:NSLocalizedString(@"Total of %@\r%d bicycle slots.", @"Description presented to the user as search results in spotlight"), station.name, station.totalSlots];

        NSString *uniqueIdentifier = [NSString stringWithFormat:@"station=%@&network=%@", station.id, network.id];
        CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:uniqueIdentifier domainIdentifier:@"com.raulriera.bikecompass" attributeSet:attributeSet];
        
        [items addObject:item];
    }];

    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:items completionHandler: ^(NSError * __nullable error) {
        NSLog(@"Stations for '%@' indexed", network.name);
        [self setIndexStatus:SpotlightIndexStatusIndexed forNetwork:network];
    }];
}

# pragma mark -

+ (SpotlightIndexStatus)indexStatusForNetwork:(Network *)network
{
    NSUserDefaults *sharedUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:AppGroupKey];
    
    if ([sharedUserDefaults boolForKey:network.id]) {
        return SpotlightIndexStatusIndexed;
    } else {
        return SpotlightIndexStatusMissing;
    }
}

+ (void)setIndexStatus:(SpotlightIndexStatus)indexStatus forNetwork:(Network *)network
{
    NSUserDefaults *sharedUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:AppGroupKey];
    
    if (indexStatus == SpotlightIndexStatusIndexed) {
        [sharedUserDefaults setBool:YES forKey:network.id];
    } else {
        [sharedUserDefaults setBool:NO forKey:network.id];
    }
}

@end
