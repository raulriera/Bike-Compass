//
//  RoundedButton.m
//  BikeCompass
//
//  Created by Raúl Riera on 30/10/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "RoundedButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundedButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self style];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.layer.cornerRadius = self.cornerRadius;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = self.borderWidth;
    self.clipsToBounds = YES;
}

#pragma mark - Default runtime attributes

- (NSInteger)defaultCornerRadius
{
    return 4.0f;
}

- (UIColor *)defaultBorderColor
{
    return [UIColor clearColor];
}

- (NSInteger)defaultBorderWidth
{
    return 0.0f;
}

#pragma mark -

- (void)style
{
    self.cornerRadius = [self defaultCornerRadius];
    self.borderColor = [self defaultBorderColor];
    self.borderWidth = [self defaultBorderWidth];
}

#pragma mark -

- (void)prepareForInterfaceBuilder
{
    [self style];
}

@end
