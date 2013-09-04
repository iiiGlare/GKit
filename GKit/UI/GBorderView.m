//
//  GBorderView.m
//  GKitDemo
//
//  Created by Hua Cao on 13-9-3.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GBorderView.h"
#import "GCore.h"

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
    
    CGFloat selfWidth = self.width;
    CGFloat selfHeight = self.height;
    CGFloat shadowOffsetWidth = self.shadowOffset.width;
    CGFloat shadowOffsetHeight = self.shadowOffset.height;
    
    // shadow
    [self.shadowColor setFill];
    
    UIBezierPath * shadowPath = [[UIBezierPath alloc] init];
    if (shadowOffsetWidth==0 && shadowOffsetHeight>0) {
        CGFloat beginY = selfHeight-shadowOffsetHeight-_cornerRadius;
        [shadowPath moveToPoint:CGPointMake(0, beginY)];
        [shadowPath addArcWithCenter:CGPointMake(_cornerRadius, beginY) radius:_cornerRadius startAngle:GRadiansFromDegrees(180) endAngle:GRadiansFromDegrees(90) clockwise:NO];
        [shadowPath addLineToPoint:CGPointMake(selfWidth-_cornerRadius, beginY+_cornerRadius)];
        [shadowPath addArcWithCenter:CGPointMake(selfWidth-_cornerRadius, beginY) radius:_cornerRadius startAngle:GRadiansFromDegrees(90) endAngle:GRadiansFromDegrees(0) clockwise:NO];
        [shadowPath addLineToPoint:CGPointMake(selfWidth, beginY+shadowOffsetHeight)];
        [shadowPath addArcWithCenter:CGPointMake(selfWidth-_cornerRadius, beginY+shadowOffsetHeight) radius:_cornerRadius startAngle:GRadiansFromDegrees(0) endAngle:GRadiansFromDegrees(90) clockwise:YES];
        [shadowPath addLineToPoint:CGPointMake(_cornerRadius, beginY+shadowOffsetHeight+_cornerRadius)];
        [shadowPath addArcWithCenter:CGPointMake(_cornerRadius, beginY+shadowOffsetHeight) radius:_cornerRadius startAngle:GRadiansFromDegrees(90) endAngle:GRadiansFromDegrees(180) clockwise:YES];
        [shadowPath addLineToPoint:CGPointMake(0, beginY)];
        [shadowPath closePath];
    }
    else {
        goto drawBorder;
    }
    [shadowPath fill];
    
    // border
drawBorder:
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
