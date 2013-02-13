//
//  UIView+GKit.m
//  YouHuo
//
//  Created by Glare on 13-2-13.
//
//

#import "UIView+GKit.h"

CGRect CGRectSetX(CGRect rect, CGFloat x) {
	return CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height);
}


CGRect CGRectSetY(CGRect rect, CGFloat y) {
	return CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height);
}


CGRect CGRectSetWidth(CGRect rect, CGFloat width) {
	return CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height);
}


CGRect CGRectSetHeight(CGRect rect, CGFloat height) {
	return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height);
}


CGRect CGRectSetOrigin(CGRect rect, CGPoint origin) {
	return CGRectMake(origin.x, origin.y, rect.size.width, rect.size.height);
}


CGRect CGRectSetSize(CGRect rect, CGSize size) {
	return CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height);
}


CGRect CGRectSetZeroOrigin(CGRect rect) {
	return CGRectMake(0.0f, 0.0f, rect.size.width, rect.size.height);
}


CGRect CGRectSetZeroSize(CGRect rect) {
	return CGRectMake(rect.origin.x, rect.origin.y, 0.0f, 0.0f);
}


CGSize CGSizeAspectScaleToSize(CGSize size, CGSize toSize) {
	// Probably a more efficient way to do this...
	CGFloat aspect = 1.0f;
	
	if (size.width > toSize.width) {
		aspect = toSize.width / size.width;
	}
	
	if (size.height > toSize.height) {
		aspect = fminf(toSize.height / size.height, aspect);
	}
	
	return CGSizeMake(size.width * aspect, size.height * aspect);
}


CGRect CGRectAddPoint(CGRect rect, CGPoint point) {
	return CGRectMake(rect.origin.x + point.x, rect.origin.y + point.y, rect.size.width, rect.size.height);
}


@implementation UIView (GKit)

- (void)setX:(CGFloat)x{
    self.frame = CGRectSetX(self.frame, x);
}
- (void)setY:(CGFloat)y{
    self.frame = CGRectSetY(self.frame, y);
}
- (void)setWidth:(CGFloat)width{
    self.frame = CGRectSetWidth(self.frame, width);
}
- (void)setHeight:(CGFloat)height{
    self.frame = CGRectSetHeight(self.frame, height);
}
- (void)setOrigin:(CGPoint)origin{
    self.frame = CGRectSetOrigin(self.frame, origin);
}
- (void)setSize:(CGSize)size{
    self.frame = CGRectSetSize(self.frame, size);
}
- (void)setZeroOrigin{
    self.frame = CGRectSetZeroOrigin(self.frame);
}
- (void)setZeroSize{
    self.frame = CGRectSetZeroSize(self.frame);
}
- (void)sizeAspectScaleToSize:(CGSize)toSize{
    [self setSize:CGSizeAspectScaleToSize(self.frame.size, toSize)];
}
- (void)frameAddPoint:(CGPoint)point{
    self.frame = CGRectAddPoint(self.frame, point);
}

@end
