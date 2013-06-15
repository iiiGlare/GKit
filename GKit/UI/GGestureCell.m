//
//  GGestureCell.m
//  GKitDemo
//
//  Created by Hua Cao on 13-6-4.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GGestureCell.h"
#import "GCore.h"

@interface GGestureCell ()
@property (nonatomic, weak) UIPanGestureRecognizer * panGestureRecognizer;
@property (nonatomic, strong) GPoint * gPoint;
@end

@implementation GGestureCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIPanGestureRecognizer * panGR =
        [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        panGR.delegate = self;
        [self addGestureRecognizer:panGR];
        self.panGestureRecognizer = panGR;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIPanGestureRecognizer
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGR {
    
    switch (panGR.state) {
        case UIGestureRecognizerStateBegan: {
            
            _gPoint = [[GPoint alloc] init];
            _gPoint.canMoveVertical = NO;
            _gPoint.point = [panGR locationInView:self];
            
            [self layoutBottomViews];
            
            if (_delegate &&
                [_delegate respondsToSelector:@selector(gestureCellDidBeginPan:)]) {
                [_delegate gestureCellDidBeginPan:self];
            }
        }
            break;
            
        case UIGestureRecognizerStateChanged: {
            
            _gPoint.point = [panGR locationInView:self];
            
            self.contentView.x += self.gPoint.moveOffset.x;
            
            _leftBottomView.x = self.contentView.x - _leftBottomView.width;
            _rightBottomView.x = CGRectGetMaxX(self.contentView.frame);
            
            if (_delegate &&
                [_delegate respondsToSelector:@selector(gestureCellIsPanning:)]) {
                [_delegate gestureCellIsPanning:self];
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            [UIView animateWithDuration: 0.25
                             animations: ^{
                                 self.contentView.x = 0;
                                 _leftBottomView.x = 0 - _leftBottomView.width;
                                 _rightBottomView.x = self.contentView.width;
                             }
                             completion: ^(BOOL finished){
                                 
                                 [_leftBottomView removeFromSuperview];
                                 _leftBottomView = nil;
                                 
                                 [_rightBottomView removeFromSuperview];
                                 _rightBottomView = nil;
                                 
                                 if (_delegate &&
                                     [_delegate respondsToSelector:@selector(gestureCellDidEndPan:)]) {
                                     [_delegate gestureCellDidEndPan:self];
                                 }
                             }];
        }
            break;
        default:
            break;
    }
}

- (void)layoutBottomViews {
    
    UIView * leftBottomView = [[UIView alloc] initWithFrame:self.bounds];
    leftBottomView.backgroundColor = [UIColor clearColor];
    leftBottomView.x -= leftBottomView.width;
    [self insertSubview:leftBottomView atIndex:0];
    _leftBottomView = leftBottomView;
    
    UIView * rightBottomView = [[UIView alloc] initWithFrame:self.bounds];
    rightBottomView.backgroundColor = [UIColor clearColor];
    rightBottomView.x += leftBottomView.width;
    [self insertSubview:rightBottomView atIndex:0];
    _rightBottomView = rightBottomView;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer == _panGestureRecognizer) {
		UITableView *tableView = self.tableView;
		CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:tableView];
		// Make it scrolling horizontally
		return ((fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO &&
                (tableView.contentOffset.y == 0.0 && tableView.contentOffset.x == 0.0));
	}
    
	return YES;
}


@end
