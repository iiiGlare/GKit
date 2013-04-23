//
//  GPoint.h
//  GKitDemo
//
//  Created by Glare on 13-4-23.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPoint : NSObject

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGPoint moveOffset;
@property (nonatomic, assign) BOOL canMoveHorizontal;
@property (nonatomic, assign) BOOL canMoveVertical;

@end
