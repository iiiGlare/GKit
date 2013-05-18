//
//  GTextFieldCell.h
//  GKitDemo
//
//  Created by Glare on 13-5-18.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTextField.h"

@protocol GTextFieldCellDelegate;

@interface GTextFieldCell : UITableViewCell
<
 UITextFieldDelegate
>

@property (nonatomic, strong, readonly) GTextField * textField;
@property (nonatomic, weak) id<GTextFieldCellDelegate> delegate;

@end


@protocol GTextFieldCellDelegate <NSObject>

@optional

- (BOOL)textFieldCellShouldBeginEditing:(GTextFieldCell *)textFieldCell;        // return NO to disallow editing.
- (void)textFieldCellDidBeginEditing:(GTextFieldCell *)textFieldCell;           // became first responder
- (BOOL)textFieldCellShouldEndEditing:(GTextFieldCell *)textFieldCell;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldCellDidEndEditing:(GTextFieldCell *)textFieldCell;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

- (BOOL)textFieldCell:(GTextFieldCell *)textFieldCell shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;              // return NO to not change text

- (BOOL)textFieldCellShouldClear:(GTextFieldCell *)textFieldCell;               // called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldCellShouldReturn:(GTextFieldCell *)textFieldCell;              // called when 'return' key pressed. return NO to ignore.


@end
