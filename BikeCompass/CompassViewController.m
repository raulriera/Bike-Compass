//
//  CompassViewController.m
//  BikeCompass
//
//  Created by Raúl Riera on 25/08/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "CompassViewController.h"
#import "NetworksTableViewController.h"
#import "CityDetectionViewController.h"
#import "LocationManager.h"
#import <POP/POP.h>
#import "MapViewController.h"
#import <SAMSoundEffect.h>
#import "UIViewController+BlankStateViewController.h"
#import "FadeInTransitioning.h"
#import "NetworksRepository.h"
#import "StationsRepository.h"

NSString *const kMapSegue = @"ShowMapSegue";
NSString *const kNetworksSegue = @"ShowNetworksSegue";
NSString *const kCityDetectionSegue = @"ShowCityDetectionSegue";

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define IS_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)

@interface CompassViewController () <LocationManagerDelegate, MapViewControllerDelegate, NetworksViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *pointerBackground;
@property (weak, nonatomic) IBOutlet UIImageView *pointer;
@property (weak, nonatomic) IBOutlet UIButton *bicyclesRemainingButton;
@property (weak, nonatomic) IBOutlet UILabel *stationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *networkNameButton;

@property (strong, nonatomic) LocationManager *locationManager;
@property (strong, nonatomic) NSArray *stations;
@property (strong, nonatomic) FadeInTransitioning *fadeInTransitioning;

@end

@implementation CompassViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
        
    // Set the to be animated views to their initial animation
    // position. We do this so the final animated state is
    // the final position of the view
    [self setupViewsForAnimation];
    
    // Setup the click handler for the station name label
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stationNameTapped)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.stationLabel setUserInteractionEnabled:YES];
    [self.stationLabel addGestureRecognizer:tapGestureRecognizer];
    
    if ([NetworksRepository sharedRepository].currentNetwork) {
        [self updateCurrentNetwork];
        [self startSignificantChangeUpdates];
    } else {
        [self performSegueWithIdentifier:kCityDetectionSegue sender:self];
    }
    
    // Newer phones have much more space to display information
    // increase the number of lines for those
    if (IS_IPHONE_6) {
        self.stationLabel.numberOfLines = 2;
    } else if (IS_IPHONE_6_PLUS) {
        self.stationLabel.numberOfLines = 3;
    }
}

- (void)displayStationInformation
{
    // Get the previously selected network
    Network *network = [NetworksRepository sharedRepository].currentNetwork;
    
    // Get all the stations of the first network
    [[StationsRepository sharedRepository] stationsForNetwork:network withCompletionBlock:^(NSArray *stations, NSError *error) {
        
        // Find the closest station to the current location
        self.stations = [[StationsRepository sharedRepository] sortStations:stations closestToLocation:self.locationManager.currentLocation withMoreThanBikes:0];
        
        // Store the current station for future references
        Station *station = [[[StationsRepository sharedRepository] sortStations:self.stations closestToLocation:self.locationManager.currentLocation withMoreThanBikes:0] firstObject];
        [StationsRepository sharedRepository].currentStation = station;
        
        [self animateViews];
    }];
}

- (void)updateCurrentNetwork
{
    NSString *networkName = [[NetworksRepository sharedRepository].currentNetwork.name uppercaseString];
    [self.networkNameButton setTitle:networkName forState:UIControlStateNormal];
}

- (void)updateInformationWithStation:(Station *)station
{
    [StationsRepository sharedRepository].currentStation = station;
    
    // Update the station name
    self.stationLabel.text = [station.name uppercaseString];
    // Update the station bicycle count
    [self.bicyclesRemainingButton setTitle:[NSString stringWithFormat:@"%ld", (long)station.numberOfBikes] forState:UIControlStateNormal];
    
    [self pointCompassToStation:station];
    [self updateDistanceToStation:[StationsRepository sharedRepository].currentStation];
}

- (void)startSignificantChangeUpdates {
    // Prepare to init the compass
    self.locationManager = [[LocationManager alloc] init];
    
    // Makes us the delegate
    self.locationManager.delegate = self;
}

- (void)pointCompassToStation:(Station *)station
{
    // Set the coordinates of the location to be used for calculating the angle
    self.locationManager.latitudeOfTargetedPoint = station.latitude;
    self.locationManager.longitudeOfTargetedPoint = station.longitude;
    
    [SAMSoundEffect playSoundEffectNamed:@"bell"];
}

# pragma mark - Animation

- (void)setupViewsForAnimation
{
    // Scale down the compass
    self.pointerBackground.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.pointer.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    // Fade out the views
    self.networkNameButton.alpha = 0;
    self.bicyclesRemainingButton.alpha = 0;
    self.stationLabel.alpha = 0;
    self.distanceLabel.alpha = 0;
}

- (void)animateViews
{
    POPSpringAnimation *popInPointerBackground = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    popInPointerBackground.name = @"pointerBackgroundPopIn";
    popInPointerBackground.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
    popInPointerBackground.springBounciness = 15.f;
    
    [self.pointerBackground.layer pop_addAnimation:popInPointerBackground forKey:@"popIn"];
    
    POPSpringAnimation *popInPointer = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    popInPointer.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
    popInPointer.name = @"pointerPopIn";
    popInPointer.springBounciness = 5.f;
    
    [self.pointer.layer pop_addAnimation:popInPointer forKey:@"popIn"];
    
    [popInPointer setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            [self.pointer.layer pop_removeAllAnimations];
            self.pointer.transform = CGAffineTransformIdentity;
            
            [self updateInformationWithStation:[StationsRepository sharedRepository].currentStation];
            
            POPBasicAnimation *fadeInStation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
            fadeInStation.name = @"stationFadeIn";
            fadeInStation.toValue = @(1.0);
            
            [self.stationLabel.layer pop_addAnimation:fadeInStation forKey:@"fadeIn"];
            
            POPBasicAnimation *fadeInBikesRemaining = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
            fadeInBikesRemaining.name = @"bicyclesRemainingFadeIn";
            fadeInBikesRemaining.toValue = @(1.0);
            fadeInBikesRemaining.beginTime = CACurrentMediaTime() + 0.25;
            
            [self.bicyclesRemainingButton.layer pop_addAnimation:fadeInBikesRemaining forKey:@"fadeIn"];
            
            POPBasicAnimation *fadeInDistance = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
            fadeInDistance.name = @"bicyclesRemainingFadeIn";
            fadeInDistance.toValue = @(1.0);
            fadeInDistance.beginTime = CACurrentMediaTime() + 0.4;
            
            [self.distanceLabel.layer pop_addAnimation:fadeInDistance forKey:@"fadeIn"];
            
            POPBasicAnimation *fadeInNetworkName = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
            fadeInNetworkName.name = @"networkNameFadeIn";
            fadeInNetworkName.toValue = @(1.0);
            fadeInNetworkName.beginTime = CACurrentMediaTime() + 0.55;
            
            [self.networkNameButton.layer pop_addAnimation:fadeInNetworkName forKey:@"fadeIn"];
            
            // Add the image to be used as the compass on the GUI
            // this is very important because we can only animate it
            // once Facebook POP has finished with it
            self.locationManager.arrowImageView = self.pointer;
        }
    }];
}

- (void)updateDistanceToStation:(Station *)station
{
    CLLocation *stationLocation = [[CLLocation alloc] initWithLatitude:station.latitude longitude:station.longitude];
    
    CLLocationDistance distance = [self.locationManager.currentLocation distanceFromLocation:stationLocation];
    
    NSLengthFormatter *lengthFormatter = [[NSLengthFormatter alloc] init];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.maximumFractionDigits = 2;
    lengthFormatter.numberFormatter = numberFormatter;
    self.distanceLabel.text = [lengthFormatter stringFromMeters:distance];
}

# pragma mark - LocationManagerDelegate

- (void)locationManager:(CLLocationManager *)locationManager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse
        || status == kCLAuthorizationStatusAuthorizedAlways) {
        
        if (self.isBlankStateViewOverlayPresent) {
            [self removeBlankStateViewOverlay];
        }
        
        [self displayStationInformation];
    
    } else if (status == kCLAuthorizationStatusDenied) {
        [self overlayBlankStateViewWithTitle:NSLocalizedString(@"Location Services are disabled", @"Generic title when the localisation is disabled") message:NSLocalizedString(@"Please enable location services in your device 'Settings' screen", @"Instructions on how to enable location services")];
    }
}

- (void)locationManager:(CLLocationManager *)locationManager didUpdateLocation:(CLLocation *)location
{
    [self updateDistanceToStation:[StationsRepository sharedRepository].currentStation];
}

# pragma mark - MapViewControllerDelegate

- (void)mapViewController:(MapViewController *)mapViewController didSelectStation:(Station *)station
{
    [self updateInformationWithStation:station];
}

# pragma mark - NetworksTableViewControllerDelegate

- (void)viewController:(UIViewController *)viewController didChooseNetwork:(Network *)network
{
    [NetworksRepository sharedRepository].currentNetwork = network;
    [self updateCurrentNetwork];
    [self startSignificantChangeUpdates];
}

# pragma mark - Actions

- (IBAction)networkNameTapped:(UIButton *)sender {
    [self performSegueWithIdentifier:kNetworksSegue sender:self];
}

- (void)stationNameTapped
{
    [self performSegueWithIdentifier:kMapSegue sender:self];
}

# pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.fadeInTransitioning = [[FadeInTransitioning alloc] init];
    
    if ([segue.identifier isEqualToString:kMapSegue]) {
        MapViewController *mapViewController = segue.destinationViewController;
        mapViewController.stations = self.stations;
        mapViewController.currentStation = [StationsRepository sharedRepository].currentStation;
        mapViewController.delegate = self;
        mapViewController.transitioningDelegate = self.fadeInTransitioning;
        mapViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    else if ([segue.identifier isEqualToString:kNetworksSegue]) {
        NetworksTableViewController *networksTableViewController = (NetworksTableViewController *)[segue.destinationViewController topViewController];
        networksTableViewController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:kCityDetectionSegue]) {
        CityDetectionViewController *cityDetectionViewController = (CityDetectionViewController *)[segue.destinationViewController topViewController];
        cityDetectionViewController.delegate = self;
    }
}

@end
