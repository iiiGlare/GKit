//
//  GTextField.m
//  GKitDemo
//
//  Created by Glare on 13-5-6.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GTextField.h"
#import "GMath.h"

@implementation GTextField

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 2, gfloor((bounds.size.height-[self.font lineHeight])*0.5));
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 2, gfloor((bounds.size.height-[self.font lineHeight])*0.5));
}

@end
