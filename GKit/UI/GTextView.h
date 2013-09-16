//
//  GTextView.h
//  GKitDemo
//
//  Created by Glare on 13-5-18.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTextView : UITextView

@property (nonatomic, copy) NSString * placeHolder;
@property (nonatomic, strong) UIColor * placeHolderColor;
@property (nonatomic, strong) UIFont * placeHolderFont;
@property (nonatomic, assign) UIEdgeInsets placeHolderEdgeInsets;

- (void) showOrHidePlaceHolderTextView;

@end
