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

@property (weak, nonatomic) IBOutlet WKInterfaceMap *mapView;
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
    
    Network *currentNetwork = [NetworksRepository sharedRepository].currentNetwork;
    
    if (currentNetwork) {
        [[StationsRepository sharedRepository] stationsForNetwork:currentNetwork withCompletionBlock:^(NSArray *stations, NSError *error) {
            
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
}

- (void)updateInterface
{
    Station *station = [StationsRepository sharedRepository].currentStation;
    
    if (station) {
        [self updateInformationWithStation:station];
        [self updateMapWithStation:station];
    } else {
        self.stationNameLabel.text = NSLocalizedString(@"Open the iPhone app first", @"Error instruction");
        self.numberOfBikesLabel.text = nil;
    }
    
}

- (void)updateInformationWithStation:(Station *)station
{
    self.stationNameLabel.text = station.name;
    self.numberOfBikesLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%ld bikes left", @"Number of bikes left in this station"), station.numberOfBikes];
}

- (void)updateMapWithStation:(Station *)station
{
    [self.mapView removeAllAnnotations];
    
    WKInterfaceMapPinColor pinColor;
    
    if (station.numberOfBikes > 0) {
        pinColor = WKInterfaceMapPinColorGreen;
    } else {
        pinColor = WKInterfaceMapPinColorRed;
    }
    
    [self.mapView addAnnotation:CLLocationCoordinate2DMake(station.latitude, station.longitude) withPinColor:pinColor];
    [self.mapView setCoordinateRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(station.latitude, station.longitude), MKCoordinateSpanMake(0.001, 0.001))];
}

@end



