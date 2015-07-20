//
//  Repository.h
//  BikeCompass
//
//  Created by Raúl Riera on 28/08/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MTLJSONAdapter.h>

@interface Repository : NSObject

extern NSString *const __nonnull RepositoryBaseURL;
extern NSString *const __nonnull AppGroupKey;

+ (void)taskWithURL:(nonnull NSURL *)url withCompletionBlock:(nullable void (^)(NSDictionary * __nullable, NSError * __nullable))block;

@end
