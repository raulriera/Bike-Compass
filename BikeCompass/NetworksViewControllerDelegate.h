//
//  NetworksViewControllerDelegate.h
//  BikeCompass
//
//  Created by Raúl Riera on 16/09/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

@class Network;

@protocol NetworksViewControllerDelegate <NSObject>

@required

- (void)viewController:(UIViewController *)viewController didChooseNetwork:(Network *)network;

@end
