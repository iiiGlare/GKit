//
//  GEventView.h
//  CalendarDemo
//
//  Created by Glare on 13-4-19.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMove.h"

@class GEvent;

@interface GEventView : UIView
<GMoveSpriteProtocol>

@property (nonatomic, strong) GEvent * event;
@property (nonatomic, strong) NSDate * beginTime;
@property (nonatomic, strong) NSDate * endTime;
@property (nonatomic, assign) BOOL shouldMove;

@property (nonatomic, strong) UILabel * titleLabel;

@end
