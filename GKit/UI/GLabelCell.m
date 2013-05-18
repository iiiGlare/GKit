//
//  GLabelCell.m
//  GKitDemo
//
//  Created by Glare on 13-5-18.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GLabelCell.h"
#import "GCore.h"

@implementation GLabelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _label = [[GLabel alloc] init];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubviewToFill:_label];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
