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
@property (strong, nonatomic) Station *lastKnownStation;
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *numberOfBikesTextGroup;

@end

@implementation InterfaceController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self updateInterface];
    }
    return self;
}

- (void)willActivate
{
    [self updateInterfaceIfNeeded];
}

- (IBAction)didTapRefresh
{
    [self updateInterfaceIfNeeded];
}

#pragma mark - Data updates

- (void)updateCurrentStation
{
    Network *currentNetwork = [NetworksRepository sharedRepository].currentNetwork;
    
    if (currentNetwork) {
        [[StationsRepository sharedRepository] stationsForNetwork:currentNetwork withCompletionBlock:^(NSArray *stations, NSError *error) {
            
            if (!error) {
                Station *station = [StationsRepository sharedRepository].currentStation;
                // Find the most recent information about this station
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id==%@", station.id];
                NSArray *stationsFiltered = [stations filteredArrayUsingPredicate:predicate];
                [StationsRepository sharedRepository].currentStation = [stationsFiltered firstObject];
                self.lastKnownStation = station;
                
                [self updateInterface];
            }
        }];
    }

}

#pragma mark - UI updates

- (void)updateInterfaceIfNeeded
{
    if (self.lastKnownStation) {
        Station *currentStation = [StationsRepository sharedRepository].currentStation;
        
        if ([currentStation isEqual:self.lastKnownStation]) {
            if (currentStation.numberOfBikes != self.lastKnownStation.numberOfBikes) {
                [self updateInterface];
            }
        } else {
            [self updateInterface];
        }
    } else {
        [self updateCurrentStation];
    }
    
}

- (void)updateInterface
{
    Station *station = [StationsRepository sharedRepository].currentStation;
    [self updateInformationWithStation:station]; 
}

- (void)updateInformationWithStation:(Station *)station
{
    if (station) {
        [self.mapView setHidden:NO];
        [self.numberOfBikesTextGroup setHidden:NO];
        self.stationNameLabel.text = station.name;
        self.numberOfBikesLabel.text = [NSString stringWithFormat:@"%ld", station.numberOfBikes];

        [self updateMapWithStation:station];
        [self invalidateUserActivity];
    } else {
        [self.mapView setHidden:YES];
        [self.numberOfBikesTextGroup setHidden:YES];
        self.stationNameLabel.text = NSLocalizedString(@"Open the iPhone app first", @"Error instruction");
        self.numberOfBikesLabel.text = nil;
        
        [self updateUserActivity:@"com.raulriera.dublinbikes.handoff" userInfo:@{} webpageURL:nil];
    }
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
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(station.latitude, station.longitude), MKCoordinateSpanMake(0.001, 0.001))];
}

@end



