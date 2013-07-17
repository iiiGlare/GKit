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
        [self drawBorderWithColor:[UIColor blackColor]
                                 width:1.0
                          cornerRadius:3.0];
        self.shouldMove = YES;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
		_titleLabel.font = [UIFont systemFontOfSize:12.0];
		_titleLabel.numberOfLines = 0;
		_titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        [self addSubview:_titleLabel];
        
    }
    return self;
}
#pragma mark - Setter / Getter
- (void)setEvent:(GEvent *)event
{
    _event = event;
    
    self.backgroundColor = event.backgroundColor;
    
    _titleLabel.text = event.title;
    _titleLabel.textColor = event.foregroundColor;
	_titleLabel.frame = self.bounds;
	[_titleLabel sizeToFit];
}

#pragma mark - GMoveSpriteProtocol
- (BOOL)canMove
{
    return _shouldMove;
}

@end
