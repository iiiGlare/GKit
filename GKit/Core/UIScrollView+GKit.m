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
#import "UIView+GKit.h"

static NSMutableArray *_autoScrollTopViews = nil;
static NSMutableArray *_autoScrollTopTimers = nil;

static NSMutableArray *_autoScrollBottomViews = nil;
static NSMutableArray *_autoScrollBottomTimers = nil;

@implementation UIScrollView (GKit)
@dynamic autoScrollTopTimer;
@dynamic autoScrollBottomTimer;
//Seter / Getter
//Top
- (NSTimer *)autoScrollTopTimer
{
    NSUInteger index = [_autoScrollTopViews indexOfObject:self];
    if (index==NSNotFound) return nil;
    
    return [_autoScrollTopTimers objectAtPosition:index];
}
- (void)setAutoScrollTopTimer:(NSTimer *)autoScrollTopTimer
{
    if (_autoScrollTopViews==nil) _autoScrollTopViews = [NSMutableArray array];
    if (_autoScrollTopTimers==nil) _autoScrollTopTimers = [NSMutableArray array];
    
    if (autoScrollTopTimer==nil) {
        
        NSUInteger index = [_autoScrollTopViews indexOfObject:self];
        if (index==NSNotFound) return;
        
        [_autoScrollTopViews removeObjectAtPosition:index];
        [_autoScrollTopTimers removeObjectAtPosition:index];

    }else{
        [_autoScrollTopViews addObject:self];
        [_autoScrollTopTimers addObject:autoScrollTopTimer];
    }
}
//Bottom
- (NSTimer *)autoScrollBottomTimer
{
    NSUInteger index = [_autoScrollBottomViews indexOfObject:self];
    if (index==NSNotFound) return nil;
    
    return [_autoScrollBottomTimers objectAtPosition:index];
}
- (void)setAutoScrollBottomTimer:(NSTimer *)autoScrollBottomTimer
{
    if (_autoScrollBottomViews==nil) _autoScrollBottomViews = [NSMutableArray array];
    if (_autoScrollBottomTimers==nil) _autoScrollBottomTimers = [NSMutableArray array];
    
    if (autoScrollBottomTimer==nil) {
        
        NSUInteger index = [_autoScrollBottomViews indexOfObject:self];
        if (index==NSNotFound) return;
        
        [_autoScrollBottomViews removeObjectAtPosition:index];
        [_autoScrollBottomTimers removeObjectAtPosition:index];
        
    }else{
        [_autoScrollBottomViews addObject:self];
        [_autoScrollBottomTimers addObject:autoScrollBottomTimer];
    }
}

//Auto scroll to top
- (void)startAutoScrollToTop
{
    [self performSelector:@selector(setupAutoScrollToTopTimer) withObject:nil afterDelay:.5];
}
- (void)setupAutoScrollToTopTimer
{
    if (self.autoScrollTopTimer) return;
    
    [self stopAutoScroll];
    self.autoScrollTopTimer = [NSTimer scheduledTimerWithTimeInterval: 0.02
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
    if (self.autoScrollBottomTimer) return;
    
    [self stopAutoScroll];
    self.autoScrollBottomTimer = [NSTimer scheduledTimerWithTimeInterval: 0.02
                                                                  target: self
                                                                selector: @selector(autoScrollToBottom)
                                                                userInfo: nil
                                                                 repeats: YES];
}
- (void)autoScrollToBottom
{
    [self setContentOffset:CGPointMake(self.contentOffset.x, MIN(self.contentSize.height-[self height], self.contentOffset.y+1)) animated:NO];
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
    
    [self.autoScrollTopTimer invalidate];
    self.autoScrollTopTimer = nil;

    [self.autoScrollBottomTimer invalidate];
    self.autoScrollBottomTimer = nil;
}

@end
