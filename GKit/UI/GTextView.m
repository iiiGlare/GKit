//
//  GTextView.m
//  GKitDemo
//
//  Created by Glare on 13-5-18.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GTextView.h"
#import "GCore.h"

@interface GTextView ()

@property (nonatomic, strong) GTextView *placeHolderTextView;

@end

@implementation GTextView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		_placeHolderColor = [UIColor grayColor];
	}
	return self;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
	_placeHolder = [placeHolder copy];
	
	if (_placeHolderTextView==nil) {
		_placeHolderTextView = [[GTextView alloc] initWithFrame:self.bounds];
		_placeHolderTextView.backgroundColor = [UIColor clearColor];
		_placeHolderTextView.userInteractionEnabled = NO;
		_placeHolderTextView.editable = NO;
		_placeHolderTextView.font = self.font;
		_placeHolderTextView.textColor = self.placeHolderColor;
		_placeHolderTextView.textAlignment = self.textAlignment;
		
		[self addSubviewToFill:_placeHolderTextView];
	}
	
	_placeHolderTextView.text = _placeHolder;
	
	[self showOrHidePlaceHolderTextView];
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
	_placeHolderColor = placeHolderColor;
	
	if (_placeHolderTextView)
	{
		_placeHolderTextView.textColor = _placeHolderColor;
	}
}

- (void)setFont:(UIFont *)font
{
	super.font = font;
	
	if (_placeHolderTextView)
	{
		_placeHolderTextView.font =font;
	}
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
	super.textAlignment = textAlignment;
	
	if (_placeHolderTextView)
	{
		_placeHolderTextView.textAlignment = textAlignment;
	}
}

- (void)setText:(NSString *)text
{
	super.text = text;
		
	[self showOrHidePlaceHolderTextView];
}

- (void)showOrHidePlaceHolderTextView
{
	if (_placeHolderTextView)
	{
		_placeHolderTextView.hidden = self.text.length>0?YES:NO;
	}
}

@end
