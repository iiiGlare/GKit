//
//  GTextViewCell.h
//  GKitDemo
//
//  Created by Glare on 13-5-18.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTextView.h"

@protocol GTextViewCellDelegate;

@interface GTextViewCell : UITableViewCell
<
 UITextViewDelegate
>

@property (nonatomic, strong, readonly) GTextView * textView;
@property (nonatomic, weak) id<GTextViewCellDelegate> delegate;

+ (GTextView *)sharedTextView;
+ (CGFloat)heightForTitle:(NSString *)title withFont:(UIFont *)font width:(CGFloat)width;

@end

@protocol GTextViewCellDelegate <NSObject>

@optional

- (BOOL)textViewCellShouldBeginEditing:(GTextViewCell *)textViewCell;
- (BOOL)textViewCellShouldEndEditing:(GTextViewCell *)textViewCell;

- (void)textViewCellDidBeginEditing:(GTextViewCell *)textViewCell;
- (void)textViewCellDidEndEditing:(GTextViewCell *)textViewCell;

- (BOOL)textViewCell:(GTextViewCell *)textViewCell shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textViewCellDidChange:(GTextViewCell *)textViewCell;

- (void)textViewCellDidChangeSelection:(GTextViewCell *)textViewCell;


@end
