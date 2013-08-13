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

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self _segmentedButtonPressed:(UIButton *)[self viewWithTag:selectedIndex] andTriggerCallback:NO];
}

- (void)_segmentedButtonPressed:(UIButton *)button
{
    [self _segmentedButtonPressed:button andTriggerCallback:YES];
}

- (void)_segmentedButtonPressed:(UIButton *)button andTriggerCallback:(BOOL)willTrigger {
    
    if (button.tag == _selectedIndex) {
		return;
	}
    
    _selectedIndex = button.tag;
	[self.subviews enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [obj setSelected:(_selectedIndex==obj.tag?YES:NO)];
        }
    }];
    
    if (willTrigger) {
        // call back
        if (_eventHandler) {
            _eventHandler(self);
        }        
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
    
    for (UIButton *button in self.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setBackgroundImage:backgroundImage forState:controlState];
        }
    }
}

- (void)addEventHandler:(void (^)(id sender))eventHandler {
    self.eventHandler = eventHandler;
}

@end
