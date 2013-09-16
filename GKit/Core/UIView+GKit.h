//
// Created by Cao Hua <glare.ch@gmail.com> on 2012
// Copyright 2012 GKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

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
extern CGRect GRectAddSize(CGRect rect, CGSize size);

@interface UIView (GKit)

- (void) setX:(CGFloat)x;
- (void) setY:(CGFloat)y;
- (void) setWidth:(CGFloat)width;
- (void) setHeight:(CGFloat)height;
- (void) setOrigin:(CGPoint)origin;
- (void) setSize:(CGSize)size;
- (void) setZeroOrigin;
- (void) setZeroSize;
- (void) sizeAspectScaleToSize:(CGSize)toSize;
- (void) frameAddPoint:(CGPoint)point;
- (void) frameAddSize:(CGSize)size;


- (CGFloat) x;
- (CGFloat) y;
- (CGPoint) origin;
- (CGFloat) width;
- (CGFloat) height;
- (CGSize)  size;
//get the view's inner center
- (CGPoint) innerCenter;

- (void) show;
- (void) hide;

//add a subview to fill self and autoresize it
- (void) addSubviewToFill:(UIView *)aView;

//
- (void) removeAllSubviewOfClass:(Class)aClass;
- (void) removeFromSuperviewWhenSelfIsKindOfClass:(Class)aClass;
- (void) removeFromSuperviewWhenSelfIsKindOfClassWithString:(NSString *)aClassString;

//
- (UIView *) superviewOfClass:(Class)aClass;

//find view's controller or superview's controller
- (UIViewController *) viewController;

@end

@interface UIView (GDrawUtil)

- (void) drawBorderWithColor: (UIColor *)color
                       width: (CGFloat)width
                cornerRadius: (CGFloat)radius;

- (void) drawShadowWithColor: (UIColor *)color
                      offset: (CGSize)offset
                     opacity: (CGFloat)opacity
                      radius: (CGFloat)radius;

@end

@interface UIView (GAnimationUtil)

- (UIImage *) snapshot;
- (UIImageView *) snapshotView;

@end
