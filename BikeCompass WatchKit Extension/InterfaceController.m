//
//  InterfaceController.m
//  BikeCompass WatchKit Extension
//
//  Created by Raúl Riera on 22/11/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "InterfaceController.h"
#import "StationsRepository.h"

@interface InterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *stationNameLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *numberOfBikesLabel;

@end


@implementation InterfaceController

- (instancetype)initWithContext:(id)context {
    self = [super initWithContext:context];
    if (self){
        // Initialize variables here.
        // Configure interface objects here.
        NSLog(@"%@ initWithContext", self);
        
        Station *station = [StationsRepository sharedRepository].currentStation;
        self.stationNameLabel.text = station.name;
        self.numberOfBikesLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%ld bikes left", @"Number of bikes left in this station"), station.numberOfBikes];
    }
    return self;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    NSLog(@"%@ will activate", self);
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    NSLog(@"%@ did deactivate", self);
}

@end



