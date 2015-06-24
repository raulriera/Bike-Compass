//
//  MapViewController.m
//  BikeCompass
//
//  Created by Raúl Riera on 31/08/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "StationPointAnnotation.h"
#import <POP/POP.h>
#import <FBAnnotationClustering/FBAnnotationClustering.h>
#import "FBAnnotationCluster+Extended.h"
#import "MKMapView+Extended.h"

@interface MapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeButtonVerticalConstraint;
@property (strong, nonatomic) NSMutableArray *annotations;
@property (strong, nonatomic) FBClusteringManager *clusteringManager;

@property (assign, nonatomic) CGFloat closeButtonInitialVerticalConstraint;

@end

@implementation MapViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self setupViewsForAnimation];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self animateViews];
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.annotations = [[NSMutableArray alloc] init];
    
    [self.stations enumerateObjectsUsingBlock:^(Station *station, NSUInteger index, BOOL *stop) {
        
        StationPointAnnotation *point = [[StationPointAnnotation alloc] initWithStation:station];
        
        [self.annotations addObject:point];
    }];
    
    [self.mapView addAnnotations:self.annotations];
    [self zoomToStation:self.currentStation];
    self.clusteringManager = [[FBClusteringManager alloc] initWithAnnotations:self.annotations];
}

- (void)zoomToStation:(Station *)station
{
    [self.mapView zoomToFitAnnotations:@[[self annotationForStation:station]]];
    [self.mapView selectAnnotation:[self annotationForStation:station] animated:YES];
}

- (StationPointAnnotation *)annotationForStation:(Station *)station
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"station.id==%@", station.id];
    NSArray *results = [self.annotations filteredArrayUsingPredicate:predicate];
    
    return [results firstObject];
}

# pragma mark - Animation

- (void)setupViewsForAnimation
{
    // Store the initial position
    self.closeButtonInitialVerticalConstraint = self.closeButtonVerticalConstraint.constant;
    // Move the close button away from the screen
    self.closeButtonVerticalConstraint.constant = 100;
}

- (void)animateViews
{
    POPSpringAnimation *popIn = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    popIn.springBounciness = 10.0f;
    popIn.toValue = @(self.closeButtonInitialVerticalConstraint);
    popIn.beginTime = CACurrentMediaTime() + 0.5;
    [self.closeButtonVerticalConstraint pop_addAnimation:popIn forKey:@"closeButtonPopIn"];
}

# pragma mark - Actions

- (IBAction)closeTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - MKMapView Delegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [[NSOperationQueue new] addOperationWithBlock:^{
        double scale = self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width;
        NSArray *annotations = [self.clusteringManager clusteredAnnotationsWithinMapRect:mapView.visibleMapRect withZoomScale:scale];
        
        [self.clusteringManager displayAnnotations:annotations onMapView:mapView];
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    
    if ([annotation isKindOfClass:[FBAnnotationCluster class]]) {
        FBAnnotationCluster *cluster = (FBAnnotationCluster *)annotation;
        
        annView.image = [self imageFromText:[NSString stringWithFormat:@"%lu", (unsigned long)cluster.annotations.count]];
        
        return annView;
    }
    else if ([annotation isKindOfClass:[StationPointAnnotation class]]) {
        StationPointAnnotation *point = (StationPointAnnotation *)annotation;
        
        if (point.station.hasBikes) {
            annView.pinTintColor = [MKPinAnnotationView greenPinColor];
        } else {
            annView.pinTintColor = [MKPinAnnotationView redPinColor];
        }
        
        annView.canShowCallout = YES;
        annView.animatesDrop = YES;
        annView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return annView;
    }
    else {
        return nil;
    }
}

- (UIImage *)imageFromText:(NSString *)text
{
    // set the font type and size
    UIFont *font = [UIFont systemFontOfSize:18];
    CGSize size = [text sizeWithAttributes:@{ NSFontAttributeName: font}];
    CGSize circleSize = CGSizeMake(44, 44);
    UIColor *clusterColor = [UIColor colorWithRed:34.0f/255.0f green:122.0f/255.0f blue:66.0f/255.0f alpha:1];
    
    UIGraphicsBeginImageContextWithOptions(circleSize, NO, [UIScreen mainScreen].scale);
    [clusterColor set];
    CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, circleSize.width, circleSize.height));
    
    [text drawAtPoint:CGPointMake((circleSize.width/2) - (size.width/2), (circleSize.height/2) - (size.height/2)) withAttributes:@{ NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[FBAnnotationCluster class]]) {
        [self.mapView zoomToFitAnnotations:((FBAnnotationCluster*)view.annotation).annotations];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)controlC
{
    StationPointAnnotation *annotation = (StationPointAnnotation*)view.annotation;
    
    if (self.delegate) {
        [self.delegate mapViewController:self didSelectStation:annotation.station];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (MKAnnotationView *view in views) {
        if ([view.annotation isKindOfClass:[FBAnnotationCluster class]]) {
            
            // If anotation is not inside the visible map rect, skip it
            MKMapPoint point =  MKMapPointForCoordinate(view.annotation.coordinate);
            if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
                continue;
            }
            
            // Hide the view initially
            view.alpha = 0;
            
            CFTimeInterval delay = CACurrentMediaTime() + (0.01*[views indexOfObject:view]);
            
            POPSpringAnimation *popInPointerBackground = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            popInPointerBackground.name = @"clusterPopIn";
            popInPointerBackground.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.2, 0.2)];
            popInPointerBackground.springBounciness = 16.0f;
            popInPointerBackground.beginTime = delay;
            popInPointerBackground.delegate = self;
            
            [view.layer pop_addAnimation:popInPointerBackground forKey:@"popIn"];
            
            POPBasicAnimation *fadeIn = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
            fadeIn.name = @"stationFadeIn";
            fadeIn.toValue = @(1.0);
            fadeIn.duration = 0.1;
            fadeIn.beginTime = delay;
            
            [view.layer pop_addAnimation:fadeIn forKey:@"fadeIn"];
        }
    }    
}

@end
