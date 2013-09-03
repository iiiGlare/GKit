//
//  GBorderView.m
//  GKitDemo
//
//  Created by Hua Cao on 13-9-3.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GBorderView.h"
#import "UIView+GKit.h"

@implementation GBorderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.cornerRadius = 5.0f;
        self.borderColor = [UIColor blackColor];
        self.borderWidth = 1.0f;
        self.fillColor = [UIColor whiteColor];
        self.shadowColor = [UIColor whiteColor];
        self.shadowOffset = CGSizeMake(0, 1);
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // shadow
    [self.shadowColor setFill];
    CGFloat shadowOffsetWidth = self.shadowOffset.width;
    CGFloat shadowOffsetHeight = self.shadowOffset.height;
    CGRect shadowRect = CGRectMake(shadowOffsetWidth>=0?shadowOffsetWidth:0,
                                   shadowOffsetHeight>=0?shadowOffsetHeight:0,
                                   self.width-ABS(shadowOffsetWidth),
                                   self.height-ABS(shadowOffsetHeight));
    UIBezierPath * shadowPath = [UIBezierPath bezierPathWithRoundedRect:shadowRect cornerRadius:self.cornerRadius];
    [shadowPath fill];
    
    // border
    [self.borderColor setStroke];
    [self.fillColor setFill];
    CGRect borderRect = CGRectMake(shadowOffsetWidth>=0?_borderWidth*0.5:-shadowOffsetWidth,
                                   shadowOffsetHeight>=0?_borderWidth*0.5:-shadowOffsetHeight,
                                   self.width-ABS(shadowOffsetWidth)-_borderWidth,
                                   self.height-ABS(shadowOffsetHeight)-_borderWidth);
    UIBezierPath * borderPath = [UIBezierPath bezierPathWithRoundedRect:borderRect cornerRadius:self.cornerRadius];
    [borderPath setLineWidth:self.borderWidth];
    [borderPath fill];
    [borderPath stroke];
}

@end
