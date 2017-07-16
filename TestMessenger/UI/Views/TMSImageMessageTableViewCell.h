//
//  TMSImageMessageTableViewCell.h
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 11/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMSMessageCellSubtitlable.h"

@interface TMSImageMessageTableViewCell : UITableViewCell <TMSMessageCellSubtitlable>

@property (nonatomic) UIImage *image;

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end
