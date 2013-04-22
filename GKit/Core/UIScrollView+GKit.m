//
//  UIScrollView+GKit.m
//  CalendarDemo
//
//  Created by Glare on 13-4-20.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "UIScrollView+GKit.h"
#import "NSArray+GKit.h"
#import "NSMutableArray+GKit.h"

static NSMutableArray *_autoScrollViews = nil;
static NSMutableArray *_autoScrollTimers = nil;

@implementation UIScrollView (GKit)
@dynamic autoScrollTimer;
//Seter / Getter
- (NSTimer *)autoScrollTimer
{
    NSUInteger index = [_autoScrollViews indexOfObject:self];
    if (index==NSNotFound) return nil;
    
    return [_autoScrollTimers objectAtPosition:index];
}
- (void)setAutoScrollTimer:(NSTimer *)autoScrollTimer
{
    if (_autoScrollViews==nil) _autoScrollViews = [NSMutableArray array];
    if (_autoScrollTimers==nil) _autoScrollTimers = [NSMutableArray array];
    
    if (autoScrollTimer==nil) {
        
        NSUInteger index = [_autoScrollViews indexOfObject:self];
        if (index==NSNotFound) return;
        
        [_autoScrollViews removeObjectAtPosition:index];
        [_autoScrollTimers removeObjectAtPosition:index];

    }else{
        [_autoScrollViews addObject:self];
        [_autoScrollTimers addObject:autoScrollTimer];
    }
}

//Auto scroll to top
- (void)startAutoScrollToTop
{
    [self performSelector:@selector(setupAutoScrollToTopTimer) withObject:nil afterDelay:.5];
}
- (void)setupAutoScrollToTopTimer
{
    if (self.autoScrollTimer) return;
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval: 0.02
                                                            target: self
                                                          selector: @selector(autoScrollToTop)
                                                          userInfo: nil
                                                           repeats: YES];
}
- (void)autoScrollToTop
{
    [self setContentOffset:CGPointMake(self.contentOffset.x, MAX(0, self.contentOffset.y-1)) animated:NO];
}

//Auto scroll to bottom
- (void)startAutoScrollToBottom
{
    [self performSelector:@selector(setupAutoScrollToBottomTimer) withObject:nil afterDelay:.5];
}
- (void)setupAutoScrollToBottomTimer
{
    if (self.autoScrollTimer) return;
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval: 0.02
                                                            target: self
                                                          selector: @selector(autoScrollToBottom)
                                                          userInfo: nil
                                                           repeats: YES];
}
- (void)autoScrollToBottom
{
    [self setContentOffset:CGPointMake(self.contentOffset.x, MAX(0, self.contentOffset.y+1)) animated:NO];
}

//Stop
- (void)stopAutoScroll
{
    [NSObject cancelPreviousPerformRequestsWithTarget: self
                                             selector: @selector(setupAutoScrollToTopTimer)
                                               object: nil];

    [NSObject cancelPreviousPerformRequestsWithTarget: self
                                             selector: @selector(setupAutoScrollToBottomTimer)
                                               object: nil];
    [self.autoScrollTimer invalidate];
    self.autoScrollTimer = nil;
}

@end
