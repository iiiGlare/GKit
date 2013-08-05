//
//  GDetailLabelCell.m
//  GKitDemo
//
//  Created by Hua Cao on 13-8-5.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GDetailLabelCell.h"
#import "UIView+GKit.h"

@implementation GDetailLabelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        // detail label
        self.label.width -= 100;
        
        GLabel * detailLabel = [[GLabel alloc] initWithFrame:CGRectMake(self.label.width, 0, 100, self.label.height)];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:detailLabel];
        _detailLabel = detailLabel;
    }
    return self;
}

@end
