//
//  InterfaceController.m
//  BikeCompass WatchKit Extension
//
//  Created by Raúl Riera on 22/11/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "InterfaceController.h"
#import "NetworksRepository.h"
#import "StationsRepository.h"

@interface InterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *stationNameLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *numberOfBikesLabel;

@end


@implementation InterfaceController

- (instancetype)initWithContext:(id)context {
    self = [super initWithContext:context];
    if (self){
        [self updateInterface];
    }
    return self;
}

- (IBAction)didTapRefresh {
    
    [[StationsRepository sharedRepository] stationsForNetwork:[NetworksRepository sharedRepository].currentNetwork withCompletionBlock:^(NSArray *stations, NSError *error) {
        
        if (!error) {
            Station *station = [StationsRepository sharedRepository].currentStation;
            // Find the most recent information about this station
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id==%@", station.id];
            NSArray *stationsFiltered = [stations filteredArrayUsingPredicate:predicate];
            [StationsRepository sharedRepository].currentStation = [stationsFiltered firstObject];
            
            [self updateInterface];
        }
    }];
    
}

- (void)updateInterface
{
    Station *station = [StationsRepository sharedRepository].currentStation;
    self.stationNameLabel.text = station.name;
    self.numberOfBikesLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%ld bikes left", @"Number of bikes left in this station"), station.numberOfBikes];
}

@end



