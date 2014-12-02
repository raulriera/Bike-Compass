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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
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
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

}

@end
