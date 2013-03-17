//
//  GCommonMetrics.h
//  GKitDemo
//
//  Created by Hua Cao on 13-3-17.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * UIView Autoresizing Mask
 */
#define GViewAutoresizingFlexibleMargins UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin
#define GViewAutoresizingFlexibleSize UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight
#define GViewAutoresizingFlexibleAll GViewAutoresizingFlexibleMargins|GViewAutoresizingFlexibleSize

/**
 * UIView Layout
 */

//Screen
CGRect GScreenBounds(void);
CGRect GApplicationFrame(void);

//Status Bar
CGFloat GStatusBarHeight(void);

//Picker
CGFloat GPickerHeight(void);



@interface GCommonMetrics : NSObject

@end
