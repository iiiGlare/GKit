//
//  GScrollSlider.m
//  YouHuo
//
//  Created by Glare on 13-5-6.
//  Copyright (c) 2013年 3fats. All rights reserved.
//

#import "GScrollSlider.h"
#import "GCore.h"

@interface GScrollSlider ()

@property (nonatomic, assign) CGFloat contentLeftMargin; // default 5 + thumbViewSize.width/2
@property (nonatomic, assign) CGFloat contentRightMargin; // default 5 + thumbViewSize.width/2
@property (nonatomic, assign) CGFloat scalesViewWidth;
@property (nonatomic, assign) CGFloat visibleValueWidth;

@property (nonatomic, strong) UIView *minTrackView;
@property (nonatomic, strong) UIView *maxTrackView;
@property (nonatomic, strong) UIView *thumbView;
@property (nonatomic, strong) UILabel *indicator;

@property (nonatomic, strong) GPoint *gPoint;

//auto scroll
@property (nonatomic, assign) NSInteger autoScrollFlag;
@property (nonatomic, strong) NSTimer *autoScrollTimer;

@end

@implementation GScrollSlider

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self customInitialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInitialize];
    }
    return self;
}

- (void)customInitialize
{
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor blackColor];

    _scalesViewTopMargin = 0;
    _scalesViewTopMargin = 0;
    
    _trackViewHeight = 5;
    _thumbViewSize = CGSizeMake(self.height, self.height);
        
    
    _minValue = 0;
    _maxValue = 100;
    _value = 50;
    _visibleValueLength = 50;
    
    _autoScrollStepValue = 1;
    _autoScrollStepsPerSecond = 10;
    
    //scales
    _scalesView = [[UIView alloc] initWithFrame:CGRectZero];
    _scalesView.backgroundColor = [UIColor randomColor];
    [self addSubview:self.scalesView];
    
    //minTrack
    _minTrackView = [[UIView alloc] initWithFrame:CGRectZero];
    _minTrackView.backgroundColor = [UIColor randomColor];
    [self addSubview:_minTrackView];
    
    //maxTrack
    _maxTrackView = [[UIView alloc] initWithFrame:CGRectZero];
    _maxTrackView.backgroundColor = [UIColor randomColor];
    [self addSubview:_maxTrackView];
    
    //thumb
    _thumbView = [[UIView alloc] initWithFrame:CGRectZero];
    _thumbView.backgroundColor = [UIColor randomColor];
    [self addSubview:_thumbView];
    
    
    //indicator
    _indicator = [[UILabel alloc] initWithFrame:CGRectZero];
    _indicator.backgroundColor = [UIColor clearColor];
    _indicator.textColor = [UIColor whiteColor];
    _indicator.textAlignmentG = GTextAlignmentCenter;
    _indicator.font = [UIFont systemFontOfSize:14.0];
    [_thumbView addSubview:_indicator];
    
    //pan gesture
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:panGR];
    
    [self reloadSlider];
}

#pragma mark - Layout
- (void)reloadSlider
{
    _contentLeftMargin = 5 + _thumbViewSize.width/2;
    _contentRightMargin = _contentLeftMargin;

    _visibleValueWidth = self.width-_contentLeftMargin-_contentRightMargin;
    _scalesViewWidth = [self minOffsetForValue:_maxValue];
    
    self.scalesView.frame = CGRectMake(0, _scalesViewTopMargin, _scalesViewWidth, self.height-_scalesViewTopMargin-_scalesViewBottomMargin);
    self.minTrackView.frame = CGRectMake(0, 0, 0, _trackViewHeight);
    self.maxTrackView.frame = CGRectMake(0, 0, 0, _trackViewHeight);
    self.thumbView.frame = CGRectMake(0, 0, _thumbViewSize.width, _thumbViewSize.height);
    self.indicator.frame = self.thumbView.bounds;
    
    [self setValue:_value animated:NO];
}

#pragma mark - Setter / Getter
- (void)setValue:(CGFloat)value
{
    _value = value;
    self.indicator.text = [NSString stringWithFormat:@"%.1f",value];
}

#pragma mark - Action
- (void)setValue:(CGFloat)value animated:(BOOL)animated
{
    self.value = value;
    
    //layout
    CGFloat minOffset = [self minOffsetForValue:value];
    CGFloat maxOffset = [self maxOffsetForValue:value];
    CGFloat centerX;
    CGFloat halfWidth = self.width/2;
    if (maxOffset>halfWidth) {
        centerX = MIN(minOffset+_contentLeftMargin, halfWidth);
    }else {
        centerX = self.width - MIN(maxOffset+_contentRightMargin, self.width/2);
    }
    CGFloat centerY = self.height/2;
    self.thumbView.center = CGPointMake(centerX, centerY);
    
    [self changeVisibleValues];
    
    [self trackThumbView];
}


#pragma mark - Utils
- (CGFloat)minOffsetForValue:(CGFloat)value
{
    return ((value-_minValue)/_visibleValueLength) * _visibleValueWidth;
}
- (CGFloat)maxOffsetForValue:(CGFloat)value
{
    return ((_maxValue-value)/_visibleValueLength) * _visibleValueWidth;
}
- (CGFloat)valueForWidth:(CGFloat)width
{
    return width * _visibleValueLength / _visibleValueWidth;
}


- (void)trackThumbView
{    
    CGFloat minTrackViewWidth = _visibleValueWidth * (self.value-_minValue) / _visibleValueLength;
    CGFloat maxTrackViewWidth = _scalesViewWidth - minTrackViewWidth;
    self.minTrackView.width = minTrackViewWidth;
    self.maxTrackView.width = maxTrackViewWidth;

    CGFloat thumbCenterX = self.thumbView.center.x;
    CGFloat thumbCenterY = self.thumbView.center.y;
    self.minTrackView.center = CGPointMake(thumbCenterX-_minTrackView.width/2, thumbCenterY);
    self.maxTrackView.center = CGPointMake(thumbCenterX+_maxTrackView.width/2, thumbCenterY);
    
    self.scalesView.x = self.minTrackView.x;
}


- (void)thumbViewAddOffset:(CGPoint)offset
{
    CGFloat newThumbCenterX = MIN(self.width-_contentRightMargin,
                                  MAX(_contentLeftMargin,_thumbView.center.x+offset.x));
    CGFloat oldValue = self.value;
    self.value = _visibleMinValue + [self valueForWidth:newThumbCenterX-_contentLeftMargin];
    
    self.thumbView.center = CGPointMake(newThumbCenterX, _thumbView.center.y);

    [self trackThumbView];
    
    if (oldValue!=self.value) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)changeVisibleValues
{
    _visibleMinValue = self.value - [self valueForWidth:_thumbView.center.x-_contentLeftMargin];
    _visibleMaxValue = _visibleMinValue + _visibleValueLength;
}

#pragma mark - Gesture Recognizer
- (void)handlePan:(UIPanGestureRecognizer *)panGR
{
    switch (panGR.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint location = [panGR locationInView:self];
            
            UIView *subview = [self hitTest:location withEvent:nil];
            if (![subview isEqual:self.thumbView]) {
                [self cancelPan:panGR];
                return;
            }
            
            _gPoint = [[GPoint alloc] init];
            _gPoint.canMoveVertical = NO;
            _gPoint.point = location;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            
            _gPoint.point = [panGR locationInView:self];
            [self thumbViewAddOffset:_gPoint.moveOffset];
            
            if (_thumbView.center.x<=_contentLeftMargin) {
                _autoScrollFlag = -1;
                [self beginAutoScroll];
            }else if (_thumbView.center.x>=self.width-_contentRightMargin){
                _autoScrollFlag = 1;
                [self beginAutoScroll];
            }else {
                _autoScrollFlag = 0;
                [self cancelAutoScroll];                
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self cancelAutoScroll];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            [self cancelAutoScroll];
        }
            break;
        default:
            break;
    }
    
    
}

- (void)cancelPan:(UIPanGestureRecognizer *)gestureRecognizer
{
    [gestureRecognizer setEnabled:NO];
    [gestureRecognizer setEnabled:YES];
}

#pragma mark - Auto Scroll
- (void)beginAutoScroll
{
    if (self.autoScrollTimer)
    {
        return;
    }
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0/_autoScrollStepsPerSecond
                                                            target: self
                                                          selector: @selector(handleAutoScroll)
                                                          userInfo: nil
                                                           repeats: YES];
}

- (void)handleAutoScroll
{
    CGFloat oldValue = self.value;
    self.value += _autoScrollFlag * _autoScrollStepValue;
    if (self.value<=self.minValue)
    {
        [self cancelAutoScroll];
        self.value = self.minValue;
    }
    if (self.value>=self.maxValue) {
        [self cancelAutoScroll];
        self.value = self.maxValue;
    }
    
    [self changeVisibleValues];
    [self trackThumbView];
    
    if (oldValue!=self.value) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)cancelAutoScroll
{
    if (self.autoScrollTimer) {
        [self.autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
}

@end
