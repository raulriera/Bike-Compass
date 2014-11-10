//
//  NetworkTableViewCell.h
//  BikeCompass
//
//  Created by Raúl Riera on 16/09/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *networkTitle;
@property (weak, nonatomic) IBOutlet UILabel *networkSubtitle;

@end
