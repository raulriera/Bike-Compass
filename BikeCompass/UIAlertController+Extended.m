//
//  UIAlertController+Extended.m
//  BikeCompass
//
//  Created by Raúl Riera on 24/09/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "UIAlertController+Extended.h"

@implementation UIAlertController (Extended)

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message acceptanceBlock:(void (^)(UIAlertAction *action))block
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:NSLocalizedString(@"OK", nil)
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action) {
                             block(action);
                         }];
    
    [alert addAction:ok];
    
    return alert;
}



@end
