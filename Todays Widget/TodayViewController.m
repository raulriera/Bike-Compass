//
//  TodayViewController.m
//  Todays Widget
//
//  Created by Raúl Riera on 02/12/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "NetworksRepository.h"
#import "StationsRepository.h"

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfBikesLabel;

@end

@implementation TodayViewController

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    Network *currentNetwork = [NetworksRepository sharedRepository].currentNetwork;
    
    if (currentNetwork) {
        [[StationsRepository sharedRepository] stationsForNetwork:currentNetwork withCompletionBlock:^(NSArray *stations, NSError *error) {
            
            if (!error) {
                Station *station = [StationsRepository sharedRepository].currentStation;
                // Find the most recent information about this station
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id==%@", station.id];
                NSArray *stationsFiltered = [stations filteredArrayUsingPredicate:predicate];
                
                station = [stationsFiltered firstObject];
                [StationsRepository sharedRepository].currentStation = station;
                
                self.stationNameLabel.text = station.name;
                self.numberOfBikesLabel.text = [NSString stringWithFormat:@"%ld", (long)station.numberOfBikes];
                
                completionHandler(NCUpdateResultNewData);
            } else {
                completionHandler(NCUpdateResultFailed);
            }
        }];
    }

}

@end
