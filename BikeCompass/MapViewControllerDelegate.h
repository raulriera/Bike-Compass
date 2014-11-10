//
//  MapViewControllerDelegate.h
//  BikeCompass
//
//  Created by Raúl Riera on 04/09/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

@class MapViewController;
@class Station;

@protocol MapViewControllerDelegate <NSObject>

@required

- (void)mapViewController:(MapViewController *)mapViewController didSelectStation:(Station *)station;

@end
