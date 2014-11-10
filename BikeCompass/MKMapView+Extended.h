//
//  MKMapView+Extended.h
//  BikeCompass
//
//  Created by Raúl Riera on 18/09/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (Extended)

- (void)zoomToFitAnnotations:(NSArray *)annotations;

@end
