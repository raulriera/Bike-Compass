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
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *numberOfBikesGroup;

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
    
    // Update the Handoff user activity
    [self updateUserActivity:@"com.raulriera.dublinbikes.handoff" userInfo:@{@"screen": @"initial"} webpageURL:nil];
    
    // Update the last known station
    self.lastKnownStation = station;
}

- (void)updateInformationWithStation:(Station *)station
{
    if (station) {
        [self.mapView setHidden:NO];
        self.stationNameLabel.text = station.name;
        self.numberOfBikesLabel.text = [NSString stringWithFormat:@"%ld", (long)station.numberOfBikes];
        [self updateRingForStation:station];
        [self updateMapWithStation:station];
    } else {
        [self.mapView setHidden:YES];
        self.stationNameLabel.text = NSLocalizedString(@"Please allow Location Services on the iPhone app", @"Error instruction");
        self.numberOfBikesLabel.text = nil;
    }
}

- (void)updateRingForStation:(Station *)station
{
    NSTimeInterval duration = 0.7;
    NSInteger fromValue = 1;
    NSInteger toValue = 22;
    
    float calculatedToValue = (float)station.numberOfBikes / ((float)station.numberOfBikes + (float)station.emptySlots);
    calculatedToValue = ceil(calculatedToValue * toValue);
    
    if (calculatedToValue == 0) {
        calculatedToValue = 1;
    }
    
    // Reverse the animation if the number of bikes decreased
    if (station.numberOfBikes < self.lastKnownStation.numberOfBikes) {
        duration *= -1;
    }
    
    [self.numberOfBikesGroup setBackgroundImageNamed:@"Ring-"];
    [self.numberOfBikesGroup startAnimatingWithImagesInRange:NSMakeRange(fromValue, calculatedToValue) duration:duration repeatCount:1];
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



