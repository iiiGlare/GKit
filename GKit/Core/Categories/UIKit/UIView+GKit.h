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

extern CGRect GRectSetX(CGRect rect, CGFloat x);
extern CGRect GRectSetY(CGRect rect, CGFloat y);
extern CGRect GRectSetWidth(CGRect rect, CGFloat width);
extern CGRect GRectSetHeight(CGRect rect, CGFloat height);
extern CGRect GRectSetOrigin(CGRect rect, CGPoint origin);
extern CGRect GRectSetSize(CGRect rect, CGSize size);
extern CGRect GRectSetZeroOrigin(CGRect rect);
extern CGRect GRectSetZeroSize(CGRect rect);
extern CGSize GSizeAspectScaleToSize(CGSize size, CGSize toSize);
extern CGRect GRectAddPoint(CGRect rect, CGPoint point);

/**
 */
#define GViewAutoresizingFlexibleMargins UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin
#define GViewAutoresizingFlexibleSize UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight
#define GViewAutoresizingFlexibleAll GViewAutoresizingFlexibleMargins|GViewAutoresizingFlexibleSize

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
