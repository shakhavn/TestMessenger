//
//  TMSImageMessageTableViewCell.m
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 11/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import "TMSImageMessageTableViewCell.h"

@interface TMSImageMessageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;

@end

@implementation TMSImageMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.pictureView.image = image;
}

@end
