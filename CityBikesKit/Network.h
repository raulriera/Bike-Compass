//
//  Network.h
//  BikeCompass
//
//  Created by Raúl Riera on 26/08/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "Location.h"

@interface Network : Model

@property (strong, nonatomic, nonnull) NSString *href;
@property (strong, nonatomic, nonnull) NSString *id;
@property (strong, nonatomic, nonnull) NSString *name;
@property (strong, nonatomic, nonnull) Location *location;

@end