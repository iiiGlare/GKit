//
//  GEventView.m
//  CalendarDemo
//
//  Created by Glare on 13-4-19.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GEventView.h"
#import "GCore.h"
#import "GEvent.h"

@interface GEventView ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation GEventView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor orangeColor];
        [self drawBorderWithColor:[UIColor blackColor]
                                 width:2.0
                          cornerRadius:5.0];
        self.shouldMove = YES;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignmentG = GTextAlignmentCenter;
        [self addSubviewToFill:_titleLabel];
        
    }
    return self;
}
#pragma mark - Setter / Getter
- (void)setEvent:(GEvent *)event
{
    _event = event;
    _titleLabel.text = event.title;
}

#pragma mark - GMoveSpriteProtocol
- (BOOL)canMove
{
    return _shouldMove;
}

@end
