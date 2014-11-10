//
//  CityDetectionUIViewController.h
//  BikeCompass
//
//  Created by Raúl Riera on 28/10/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworksViewControllerDelegate.h"

@interface CityDetectionViewController : UIViewController

@property (assign, nonatomic) id <NetworksViewControllerDelegate> delegate;

@end
