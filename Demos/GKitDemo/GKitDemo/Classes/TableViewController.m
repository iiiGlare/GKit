//
//  TableViewController.m
//  GKitDemo
//
//  Created by Glare on 13-5-18.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "TableViewController.h"
#import "GCore.h"

#import "GLabelCell.h"
#import "GTextFieldCell.h"
#import "GTextViewCell.h"

@interface TableViewController ()
<
 GTextFieldCellDelegate, GTextViewCellDelegate
>

@end

@implementation TableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        //Label Cell
        static NSString * CellIdentifier = @"LabelCell";

        GLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[GLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;

    } else if (indexPath.row==1) {
        //Text Field Cell
        static NSString * CellIdentifier = @"TextFieldCell";
        
        GTextFieldCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[GTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.delegate = self;
        }
        return cell;
        
    } else {
        //Text View Cell
        static NSString * CellIdentifier = @"TextViewCell";
        
        GTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[GTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textView.returnKeyType = UIReturnKeyDone;
            cell.delegate = self;
        }
        return cell;
    }
    
    return [super cellForTableView:tableView atIndexPath:indexPath];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //Label Cell
        GLabelCell *labelCell = (GLabelCell *)cell;
        labelCell.label.text = @"label cell";
        
    } else if (indexPath.row == 1) {
        //Text Field Cell
        GTextFieldCell *textFieldCell = (GTextFieldCell *)cell;
        textFieldCell.textField.text = @"text field cell";
        
    } else {
        //Text View Cell
        GTextViewCell *textViewCell = (GTextViewCell *)cell;
        textViewCell.textView.text = @"text view cell";
		textViewCell.textView.placeHolder = @"placeholder";
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - GTextFieldCellDelegate
- (BOOL)textFieldCellShouldReturn:(GTextFieldCell *)textFieldCell
{
    [textFieldCell.textField resignFirstResponder];
    
    return NO;
}

#pragma mark - GTextViewCellDelegate
- (BOOL)textViewCell:(GTextViewCell *)textViewCell shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textViewCell.textView resignFirstResponder];
        
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - Pop Control
- (void)willPop
{
	GPRINT(@"willPop");
}

@end
