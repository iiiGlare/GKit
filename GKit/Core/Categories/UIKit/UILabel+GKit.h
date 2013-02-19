//
//  UILabel+GKit.h
//  YouHuo
//
//  Created by Glare on 13-2-18.
//
//

#import <UIKit/UIKit.h>
enum {
    GTextAlignmentLeft      = 0,
    GTextAlignmentCenter    = 1,
    GTextAlignmentRight     = 2,
    GTextAlignmentJustified = 3,
    GTextAlignmentNatural   = 4,
};
typedef NSInteger GTextAlignment;

@interface UILabel (GKit)
- (void) setTextAlignmentG:(GTextAlignment)textAlignment;
@end
