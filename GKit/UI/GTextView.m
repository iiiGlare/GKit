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
{
    BOOL _isCustomPlaceHolderFont;
}
@property (nonatomic, strong) GTextView *placeHolderTextView;

@end

@implementation GTextView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		_placeHolderColor = [UIColor grayColor];
        _placeHolderFont = self.font;
        _isCustomPlaceHolderFont = NO;
        _placeHolderEdgeInsets = UIEdgeInsetsZero;
	}
	return self;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
	_placeHolder = [placeHolder copy];
	
	if (_placeHolderTextView==nil) {
		_placeHolderTextView = [[GTextView alloc] initWithFrame:CGRectMake(_placeHolderEdgeInsets.left, _placeHolderEdgeInsets.top, self.width-_placeHolderEdgeInsets.left-_placeHolderEdgeInsets.right, self.height-_placeHolderEdgeInsets.top-_placeHolderEdgeInsets.bottom)];
		_placeHolderTextView.backgroundColor = [UIColor clearColor];
		_placeHolderTextView.userInteractionEnabled = NO;
		_placeHolderTextView.editable = NO;
		_placeHolderTextView.font = self.placeHolderFont;
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

- (void)setPlaceHolderFont:(UIFont *)placeHolderFont {
    
    _placeHolderFont = placeHolderFont;
    _isCustomPlaceHolderFont = YES;
    
    if (_placeHolderTextView) {
        _placeHolderTextView.font = _placeHolderFont;
    }
}

- (void)setPlaceHolderEdgeInsets:(UIEdgeInsets)placeHolderEdgeInsets {
    
    _placeHolderEdgeInsets = placeHolderEdgeInsets;
    
    if (_placeHolderTextView) {
        _placeHolderTextView.frame = CGRectMake(_placeHolderEdgeInsets.left, _placeHolderEdgeInsets.top, self.width-_placeHolderEdgeInsets.left-_placeHolderEdgeInsets.right, self.height-_placeHolderEdgeInsets.top-_placeHolderEdgeInsets.bottom);
    }
}

- (void)setFont:(UIFont *)font
{
	super.font = font;
	
    if (_isCustomPlaceHolderFont==NO) {
        _placeHolderFont = font;
        if (_placeHolderTextView) {
            _placeHolderTextView.font =font;
        }
    }    
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
	super.textAlignment = textAlignment;
	
	if (_placeHolderTextView) {
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
