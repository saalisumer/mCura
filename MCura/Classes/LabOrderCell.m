//
//  LabOrderCell.m
//  mCura
//
//  Created by Aakash Chaudhary on 20/05/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "LabOrderCell.h"

@implementation LabOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x,0.0, 
                                      self.textLabel.frame.size.width,44.0);
    self.textLabel.backgroundColor = [UIColor clearColor];
}

@end
