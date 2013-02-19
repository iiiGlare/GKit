//
//  NSDate+GKit.h
//  YouHuo
//
//  Created by Glare on 13-2-18.
//
//

#import <Foundation/Foundation.h>

/**
 */
NSTimeInterval GTimeIntervalFromMinitues(NSUInteger minutes);
NSTimeInterval GTimeIntervalFromHours(NSUInteger hours);
NSTimeInterval GTimeIntervalFromDays(NSUInteger days);
NSTimeInterval GTimeIntervalFromWeeks(NSUInteger weeks);

@interface NSDate (GKit)

@end
