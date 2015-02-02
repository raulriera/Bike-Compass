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
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id==%@", station.id];
                NSArray *stationsFiltered = [stations filteredArrayUsingPredicate:predicate];
                
                station = [stationsFiltered firstObject];
                [StationsRepository sharedRepository].currentStation = station;
                
                [self updateWidgetWithStation:station];
                
                completionHandler(NCUpdateResultNewData);
            } else {
                completionHandler(NCUpdateResultFailed);
            }
        }];
    } else {
        self.stationNameLabel.text = NSLocalizedString(@"Open the iPhone app first", @"Error instruction");
        completionHandler(NCUpdateResultFailed);
    }
}

- (void)updateWidgetWithStation:(Station *)station
{
    self.stationNameLabel.text = station.name;
    self.numberOfBikesLabel.text = [NSString stringWithFormat:@"%ld", (long)station.numberOfBikes];
    self.numberOfBikesLabel.layer.cornerRadius = 6;
    
    if (station.numberOfBikes > 0) {
        self.numberOfBikesLabel.backgroundColor = [UIColor colorWithRed:34.0f/255.0f green:122.0f/255.0f blue:66.0f/255.0f alpha:1];
    } else {
        self.numberOfBikesLabel.backgroundColor = [UIColor colorWithRed:241.0f/255.0f green:23.0f/255.0f blue:23.0f/255.0f alpha:1];
    }
    
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender
{
    NSURL *url = [NSURL URLWithString:@"bikecompass://"];
    [self.extensionContext openURL:url completionHandler:nil];
}


@end
