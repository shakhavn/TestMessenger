//
//  TMSTextMessageTableViewCell.m
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 11/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import "TMSTextMessageTableViewCell.h"

@interface TMSTextMessageTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation TMSTextMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTextMessage:(NSString *)textMessage {
    _textMessage = textMessage;
    self.messageLabel.text = textMessage;
}

@end
