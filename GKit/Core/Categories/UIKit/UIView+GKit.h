//
//  UIView+GKit.h
//  YouHuo
//
//  Created by Glare on 13-2-13.
//
//

#import <UIKit/UIKit.h>
///-----------------------------
/// @name Rectangle Manipulation
///-----------------------------

extern CGRect CGRectSetX(CGRect rect, CGFloat x);
extern CGRect CGRectSetY(CGRect rect, CGFloat y);
extern CGRect CGRectSetWidth(CGRect rect, CGFloat width);
extern CGRect CGRectSetHeight(CGRect rect, CGFloat height);
extern CGRect CGRectSetOrigin(CGRect rect, CGPoint origin);
extern CGRect CGRectSetSize(CGRect rect, CGSize size);
extern CGRect CGRectSetZeroOrigin(CGRect rect);
extern CGRect CGRectSetZeroSize(CGRect rect);
extern CGSize CGSizeAspectScaleToSize(CGSize size, CGSize toSize);
extern CGRect CGRectAddPoint(CGRect rect, CGPoint point);

@interface UIView (GKit)

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setOrigin:(CGPoint)origin;
- (void)setSize:(CGSize)size;
- (void)setZeroOrigin;
- (void)setZeroSize;
- (void)sizeAspectScaleToSize:(CGSize)toSize;
- (void)frameAddPoint:(CGPoint)point;

@end
