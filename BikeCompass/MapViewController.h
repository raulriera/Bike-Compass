//
//  MapViewController.h
//  BikeCompass
//
//  Created by Raúl Riera on 31/08/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Station.h"
#import "MapViewControllerDelegate.h"

@interface MapViewController : UIViewController

@property (strong, nonatomic) NSArray *stations;
@property (strong, nonatomic) Station *currentStation;
@property (assign, nonatomic) id <MapViewControllerDelegate> delegate;

@end
