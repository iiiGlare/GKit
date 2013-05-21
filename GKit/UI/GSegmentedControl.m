//
//  GSegmentedControl.m
//  competitionReminder
//
//  Created by 华 曹 on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GSegmentedControl.h"
#import "GCore.h"

@implementation GSegmentedControl

+ (GSegmentedControl *)segmentedControlWithTitles:(NSArray *)titles
{	
	int count = [titles count];
	
	GSegmentedControl *segmentedControl = [[GSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	segmentedControl.backgroundColor = [UIColor clearColor];
	segmentedControl.tag = count;
	
	CGFloat w = 320.0f/count;
	CGFloat h = 44.0f;
	
	for (int i=0; i<count; i++) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.tag = i;
		button.frame = CGRectMake(i*w, 0, w, h);
		button.autoresizingMask = GViewAutoresizingFlexibleAll;
		[button setAdjustsImageWhenHighlighted:NO];
		[button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
		[button addTarget: segmentedControl
                   action: @selector(_segmentedButtonPressed:)
         forControlEvents: UIControlEventTouchUpInside];
		[segmentedControl addSubview:button];
		if (i == segmentedControl.selectedIndex) {
			button.selected = YES;
		}
	}
	
	return segmentedControl;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_selectedIndex = 0;
    }
    return self;
}

- (void)_segmentedButtonPressed:(UIButton *)button
{
	if (button.tag == _selectedIndex) {
		return;
	}
	
	[button setBackgroundImage:self.selectedBackgroundImage forState:UIControlStateNormal];
	[button setSelected:YES];
    
	[(UIButton *)[self viewWithTag:_selectedIndex] setBackgroundImage:self.normalBackgroundImage forState:UIControlStateNormal];
	[(UIButton *)[self viewWithTag:_selectedIndex] setSelected:NO];
    
	_selectedIndex = button.tag;
	
	if (_target &&
        [_target respondsToSelector:_action]) {
        
		[_target performSelector:_action withObject:self];
	}
	
}

- (void)setFont:(UIFont *)font {
    
	for (UIButton *button in self.subviews) {
		if ([button isKindOfClass:[UIButton class]]) {
			[button.titleLabel setFont:font];
		}
	}
}

- (void)setTextColor:(UIColor *)color forControlSate:(UIControlState)controlState {
    
	for (UIButton *button in self.subviews) {
		if ([button isKindOfClass:[UIButton class]]) {
			[button setTitleColor:color forState:controlState];
		}
	}	
}

- (void)setBackgroundImage:(UIImage *)backgroundImage forControlSate:(UIControlState)controlState {
    
	if (UIControlStateNormal==controlState) {
		self.normalBackgroundImage = backgroundImage;
		for (UIButton *button in self.subviews) {
			if ([button isKindOfClass:[UIButton class]]) {
				[button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
			}
		}
	}else if (UIControlStateSelected==controlState){
		self.selectedBackgroundImage = backgroundImage;
		[(UIButton *)[self viewWithTag:_selectedIndex] setBackgroundImage:backgroundImage forState:UIControlStateNormal];
	}
}

- (void)addTarget:(id)theTarget action:(SEL)theAction {
    
	self.target = theTarget;
	self.action = theAction;
}

@end
