//
//  GEventView.m
//  CalendarDemo
//
//  Created by Glare on 13-4-19.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GEventView.h"

@implementation GEventView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
        self.shouldMove = YES;
    }
    return self;
}
- (BOOL)canMove
{
    return _shouldMove;
}
@end
