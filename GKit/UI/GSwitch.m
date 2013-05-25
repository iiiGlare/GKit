//
//  GSwitch.m
//  GKitDemo_arc
//
//  Created by Hua Cao on 12-9-12.
//  Copyright (c) 2012年 hoewo. All rights reserved.
//

#import "GSwitch.h"
#import "GCore.h"

@interface GSwitch () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *knobImageView;
@property (nonatomic, strong) UIImageView *onToggleImageView;
@property (nonatomic, strong) UIImageView *offToggleImageView;
@property (nonatomic) BOOL ignoreTap;

- (void)positionSubviews;

@end

@implementation GSwitch
@synthesize
knobImageView = _knobImageView,
onToggleImageView = _onToggleImageView,
offToggleImageView = _offToggleImageView,
onBackgroundImage = _onBackgroundImage,
offBackgroundImage = _offBackgroundImage,
ignoreTap = _ignoreTap;
@synthesize
knobImage = _knobImage,
onToggleImage = _onToggleImage,
offToggleImage = _offToggleImage;
@synthesize
knobSize = _knobSize,
toggleHeight = _toggleHeight,
stretchable = _stretchable,
knobInsets = _knobInsets,
toggleInsets = _toggleInsets;
@synthesize
on = _on;

//- (id)init
//{
//	self = [super init];
//	if (self) {
//		[self setup];
//	}
//	return self;
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//	self = [super initWithCoder:aDecoder];
//	if (self) {
//		[self setup];
//	}
//	return self;
//}
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//		[self setup];
//    }
//    return self;
//}

- (id)initWithFrame:(CGRect)frame
		  knobImage:(UIImage *)knobImage
	  onToggleImage:(UIImage *)onToggleImage
	 offToggleImage:(UIImage *)offToggleImage
{
	self = [super initWithFrame:frame];
	if (self)
	{
		_knobSize = knobImage.size;
		_toggleHeight = onToggleImage.size.height;
		_stretchable = YES;
		
		self.knobImage = knobImage;
		self.onToggleImage = onToggleImage;
		self.offToggleImage = offToggleImage;
		[self setup];
	}
	return self;
}

- (void)setup
{
	self.backgroundColor = [UIColor clearColor];
	
	//on Toggle
	self.onToggleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	[self addSubview:self.onToggleImageView];
	
	//off Toggle
	self.offToggleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	[self addSubview:self.offToggleImageView];
	
	//knob
	self.knobImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	[self addSubview:self.knobImageView];
	
	// tap gesture for toggling the switch
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
																						   action:@selector(tapped:)];
	[tapGestureRecognizer setDelegate:self];
	[self addGestureRecognizer:tapGestureRecognizer];
	
	// pan gesture for moving the switch knob manually
	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
																						   action:@selector(toggleDragged:)];
	[panGestureRecognizer setDelegate:self];
	[self addGestureRecognizer:panGestureRecognizer];
	
	[self loadImages];
	[self positionSubviews];
}

- (void)loadImages
{
	self.knobImageView.image = self.knobImage;
	if (self.stretchable) {
		CGFloat halfHeight = (int)(_toggleHeight/2);
		self.onToggleImageView.image = [self.onToggleImage resizableImageWithCapInsets:UIEdgeInsetsMake(halfHeight, halfHeight, halfHeight, halfHeight)];
		self.offToggleImageView.image = [self.offToggleImage resizableImageWithCapInsets:UIEdgeInsetsMake(halfHeight, halfHeight, halfHeight, halfHeight)];
	}else{
		self.onToggleImageView.image = self.onToggleImage;
		self.offToggleImageView.image = self.offToggleImage;
	}
}

- (void)positionSubviews
{
	///knob
	CGSize knobSize = self.knobSize;
	CGFloat minKnobX = _knobInsets.left;
	CGFloat maxKnobX = self.frame.size.width - knobSize.width - _knobInsets.right;
	CGFloat knobY = (self.frame.size.height - knobSize.height)/2 + _knobInsets.top - _knobInsets.bottom;
	
	if (self.on) {
		self.knobImageView.frame = CGRectMake(maxKnobX,
											  knobY,
											  knobSize.width,
											  knobSize.height);
	}else{
		self.knobImageView.frame = CGRectMake(minKnobX,
											  knobY,
											  knobSize.width,
											  knobSize.height);
	}
	
	///Toggle
	CGFloat bgHeight = self.toggleHeight;
	CGFloat bgY = (self.frame.size.height - bgHeight)/2;
	CGPoint knobCenter = self.knobImageView.center;
	
	self.onToggleImageView.frame = CGRectMake(_toggleInsets.left,
											  bgY + _toggleInsets.top - _knobInsets.bottom,
											  knobCenter.x - _toggleInsets.left,
											  bgHeight);
	self.offToggleImageView.frame = CGRectMake(knobCenter.x,
											   bgY + _toggleInsets.top - _knobInsets.bottom,
											   self.frame.size.width - knobCenter.x - _toggleInsets.right,
											   bgHeight);
	
}

- (void)drawRect:(CGRect)rect
{
	if (self.on) {
		if (self.onBackgroundImage) {
			[self.onBackgroundImage drawInRect:self.bounds];
		}
	}else{
		if (self.offBackgroundImage) {
			[self.offBackgroundImage drawInRect:self.bounds];
		}
	}
}

#pragma mark -
#pragma mark Interaction

- (void)tapped:(UITapGestureRecognizer *)gesture
{
	if (self.ignoreTap) return;
	
	if (gesture.state == UIGestureRecognizerStateEnded)
		[self setOn:!self.on animated:YES];
}

- (void)toggleDragged:(UIPanGestureRecognizer *)gesture
{
	
	if (gesture.state == UIGestureRecognizerStateBegan)
	{
		// setup by turning off the manual clipping of the toggleLayer and setting up a layer mask.
	}
	else if (gesture.state == UIGestureRecognizerStateChanged)
	{
		CGPoint translation = [gesture translationInView:self];
		
		///knob
		CGSize knobSize = self.knobSize;
		CGFloat minKnobX = _knobInsets.left;
		CGFloat maxKnobX = self.frame.size.width - knobSize.width - _knobInsets.right;
		CGFloat	knobX = self.knobImageView.frame.origin.x + translation.x;
		if (knobX<minKnobX) knobX = minKnobX;
		if (knobX>maxKnobX) knobX = maxKnobX;
		CGFloat knobY = (self.frame.size.height - knobSize.height)/2 + _knobInsets.top - _knobInsets.bottom;
		
		self.knobImageView.frame = CGRectMake(knobX,
											  knobY,
											  knobSize.width,
											  knobSize.height);
		
		///Toggle
		CGFloat bgHeight = self.toggleHeight;
		CGFloat bgY = (self.frame.size.height - bgHeight)/2;
		CGPoint knobCenter = self.knobImageView.center;
		
		self.onToggleImageView.frame = CGRectMake(_toggleInsets.left,
												  bgY + _toggleInsets.top - _knobInsets.bottom,
												  knobCenter.x - _toggleInsets.left,
												  bgHeight);
		self.offToggleImageView.frame = CGRectMake(knobCenter.x,
												   bgY + _toggleInsets.top - _knobInsets.bottom,
												   self.frame.size.width - knobCenter.x - _toggleInsets.right,
												   bgHeight);
		
		[gesture setTranslation:CGPointZero inView:self];
	}
	else if (gesture.state == UIGestureRecognizerStateEnded)
	{
		// flip the switch to on or off depending on which half it ends at
		CGFloat toggleCenter = CGRectGetMidX(self.knobImageView.frame);
		[self setOn:(toggleCenter > CGRectGetMidX(self.bounds)) animated:YES];
	}
	
	// send off the appropriate actions (not fully tested yet)
	CGPoint locationOfTouch = [gesture locationInView:self];
	if (CGRectContainsPoint(self.bounds, locationOfTouch))
		[self sendActionsForControlEvents:UIControlEventTouchDragInside];
	else
		[self sendActionsForControlEvents:UIControlEventTouchDragOutside];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.ignoreTap) return;
	
	[super touchesBegan:touches withEvent:event];
	
	[self sendActionsForControlEvents:UIControlEventTouchDown];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	
	[self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event];
	
	[self sendActionsForControlEvents:UIControlEventTouchUpOutside];
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
{
	return !self.ignoreTap;
}

#pragma mark Setters/Getters

- (void)setOn:(BOOL)newOn
{
	[self setOn:newOn animated:NO];
}

- (void)setOn:(BOOL)newOn animated:(BOOL)animated
{
	[self setOn:newOn animated:animated ignoreControlEvents:NO];
}

- (void)setOn:(BOOL)newOn animated:(BOOL)animated ignoreControlEvents:(BOOL)ignoreControlEvents
{
	BOOL previousOn = _on;
	_on = newOn;
	self.ignoreTap = YES;
	
	[UIView animateWithDuration:.15
						  delay:.014
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 [self setNeedsDisplay];
						 [self positionSubviews];
					 }
					 completion:^(BOOL finished){
						 
						 self.ignoreTap = NO;
						 
						 // send the action here so it get's sent at the end of the animations
						 if (previousOn != _on && !ignoreControlEvents)
							 [self sendActionsForControlEvents:UIControlEventValueChanged];
					 }];
	
}

- (void)setKnobSize:(CGSize)knobSize
{
	_knobSize = knobSize;
	[self positionSubviews];
}

- (void)setToggleHeight:(CGFloat)toggleHeight
{
	_toggleHeight = toggleHeight;
	[self loadImages];
	[self positionSubviews];
}

- (void)setStretchable:(BOOL)stretchable
{
	_stretchable = stretchable;
	[self loadImages];
	[self positionSubviews];
}

- (void)setKnobInsets:(UIEdgeInsets)knobInsets
{
	_knobInsets = knobInsets;
	[self positionSubviews];
}

- (void)setToggleInsets:(UIEdgeInsets)toggleInsets
{
	_toggleInsets = toggleInsets;
	[self positionSubviews];
}

- (void)setOnBackgroundImage:(UIImage *)onBackgroundImage
{
	_onBackgroundImage = onBackgroundImage;
	[self setNeedsDisplayInRect:self.bounds];
}

- (void)setOffBackgroundImage:(UIImage *)offBackgroundImage
{
	_offBackgroundImage = offBackgroundImage;
	[self setNeedsDisplayInRect:self.bounds];
}

@end
