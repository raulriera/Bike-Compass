//
//  UIAlertController+Extended.h
//  BikeCompass
//
//  Created by Raúl Riera on 24/09/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Extended)

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message acceptanceBlock:(void (^)(UIAlertAction *action))block;

@end
