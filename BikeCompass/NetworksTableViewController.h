//
//  NetworksTableViewController.h
//  BikeCompass
//
//  Created by Raúl Riera on 16/09/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworksViewControllerDelegate.h"

@interface NetworksTableViewController : UITableViewController

@property (assign, nonatomic) id <NetworksViewControllerDelegate> delegate;

@end
