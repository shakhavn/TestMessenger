//
//  TMSLocationMessageTableViewCell.h
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 11/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TMSMessageCellSubtitlable.h"

@interface TMSLocationMessageTableViewCell : UITableViewCell <TMSMessageCellSubtitlable>

@property (nonatomic) CLLocation *pinLocation;

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end
