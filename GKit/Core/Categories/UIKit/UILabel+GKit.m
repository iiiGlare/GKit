//
//  UILabel+GKit.m
//  YouHuo
//
//  Created by Glare on 13-2-18.
//
//

#import "UILabel+GKit.h"
#import "UIDevice+GKit.h"

@implementation UILabel (GKit)

#pragma mark - override super methods
- (void) setTextAlignmentG:(GTextAlignment)textAlignment
{
    if ([UIDevice isOSVersionHigherThanVersion:@"6.0" includeEqual:YES]) {
        [self setTextAlignment:textAlignment];
    }else{
        if (textAlignment<=GTextAlignmentRight) {
            [self setTextAlignment:textAlignment];
        }
    }
}
@end
