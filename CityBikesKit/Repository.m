//
//  Repository.m
//  BikeCompass
//
//  Created by Raúl Riera on 28/08/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "Repository.h"

@implementation Repository

NSString *const RepositoryBaseURL = @"http://api.citybik.es";
NSString *const AppGroupKey = @"group.raulriera.bikecompass";

+ (void)taskWithURL:(NSURL *)url withCompletionBlock:(void (^)(NSDictionary *, NSError *))block
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:url
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                if (error) {
                    block(nil, error);
                }
                
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

                block(json, error);
                
            }] resume];
}

@end
