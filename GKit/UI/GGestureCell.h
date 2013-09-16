//
//  GGestureCell.h
//  GKitDemo
//
//  Created by Hua Cao on 13-6-4.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GGestureCellDelegate;

@interface GGestureCell : UITableViewCell

@property (nonatomic, weak) id<GGestureCellDelegate> delegate;

@property (nonatomic, strong, readonly) UIView * leftBottomView;
@property (nonatomic, strong, readonly) UIView * rightBottomView;

@end

@protocol GGestureCellDelegate <NSObject>
@optional
- (void) gestureCellDidBeginPan:(GGestureCell *)gestureCell;
- (void) gestureCellIsPanning:(GGestureCell *)gestureCell;
- (void) gestureCellDidEndPan:(GGestureCell *)gestureCell;
@end