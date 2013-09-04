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
@property (nonatomic, weak) UITextView * placeHolderTextView;

@end

@implementation GTextView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_placeHolderColor = [UIColor grayColor];
        _placeHolderFont = self.font;
        _isCustomPlaceHolderFont = NO;
        _placeHolderEdgeInsets = UIEdgeInsetsZero;
        
        self.font = [UIFont systemFontOfSize:15.0f];
	}
	return self;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
	_placeHolder = [placeHolder copy];
	
	if (_placeHolderTextView==nil) {
		UITextView * placeHolderTextView = [[UITextView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, _placeHolderEdgeInsets)];
        placeHolderTextView.autoresizingMask = GViewAutoresizingFlexibleSize;
		placeHolderTextView.backgroundColor = [UIColor clearColor];
		placeHolderTextView.userInteractionEnabled = NO;
		placeHolderTextView.editable = NO;
		placeHolderTextView.font = self.placeHolderFont;
		placeHolderTextView.textColor = self.placeHolderColor;
		placeHolderTextView.textAlignment = self.textAlignment;
		[self addSubview:placeHolderTextView];
        _placeHolderTextView = placeHolderTextView;
	}
	
	_placeHolderTextView.text = _placeHolder;
	
	[self showOrHidePlaceHolderTextView];
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
	_placeHolderColor = placeHolderColor;
	
	if (_placeHolderTextView) {
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
        _placeHolderTextView.frame = UIEdgeInsetsInsetRect(self.bounds, _placeHolderEdgeInsets);
    }
}

- (void)setFont:(UIFont *)font {
	super.font = font;
    
    if (_isCustomPlaceHolderFont==NO) {
        _placeHolderFont = font;
        if (_placeHolderTextView) {
            _placeHolderTextView.font =font;
        }
    }
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
	super.textAlignment = textAlignment;
    
	if (_placeHolderTextView) {
		_placeHolderTextView.textAlignment = textAlignment;
	}
}

- (void)setText:(NSString *)text {
	super.text = text;
    
	[self showOrHidePlaceHolderTextView];
}

- (void)showOrHidePlaceHolderTextView {
	if (_placeHolderTextView) {
		_placeHolderTextView.hidden = self.text.length>0?YES:NO;
	}
}

@end
