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
#import "GGestureCell.h"

@interface TableViewController ()
<
 GTextFieldCellDelegate, GTextViewCellDelegate,
 GGestureCellDelegate
>

@end

@implementation TableViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        //Label Cell
        static NSString * CellIdentifier = @"LabelCell";

        GLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[GLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return cell;

    } else if (indexPath.row==1) {
        //Text Field Cell
        static NSString * CellIdentifier = @"TextFieldCell";
        
        GTextFieldCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[GTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.delegate = self;
        }
        return cell;
        
    } else if (indexPath.row==2){
        //Text View Cell
        static NSString * CellIdentifier = @"TextViewCell";
        
        GTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[GTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.textView.returnKeyType = UIReturnKeyDone;
            cell.delegate = self;
        }
        return cell;
        
    } else if (indexPath.row == 3) {
        // Gesture Cell
        static NSString * CellIdentifier = @"GestureCell";
        
        GGestureCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[GGestureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
        GLabelCell * labelCell = (GLabelCell *)cell;
        labelCell.label.text = @"label cell";
        
    } else if (indexPath.row == 1) {
        //Text Field Cell
        GTextFieldCell * textFieldCell = (GTextFieldCell *)cell;
        textFieldCell.textField.text = @"text field cell";
        
    } else if (indexPath.row == 2) {
        //Text View Cell
        GTextViewCell * textViewCell = (GTextViewCell *)cell;
        textViewCell.textView.text = @"text view cell";
		textViewCell.textView.placeHolder = @"placeholder";
        textViewCell.textView.placeHolderFont = [UIFont systemFontOfSize:12];
    } else if (indexPath.row == 3) {
        //Gesture Cell
        GGestureCell * gestureCell = (GGestureCell *)cell;
        gestureCell.textLabel.text = @"gesture cell";
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GPRINT(@"%@", indexPath);
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

#pragma mark - Gesture Cell
- (void)gestureCellDidBeginPan:(GGestureCell *)gestureCell {
    
    UILabel * label = [[UILabel alloc] initWithFrame:gestureCell.leftBottomView.bounds];
    label.textAlignmentG = GTextAlignmentRight;
    label.text = GLocalizedString(@"右拉完成");
    [gestureCell.leftBottomView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:gestureCell.rightBottomView.bounds];
    label.textAlignmentG = GTextAlignmentLeft;
    label.text = GLocalizedString(@"左拉存档");
    [gestureCell.rightBottomView addSubview:label];

}
- (void)gestureCellIsPanning:(GGestureCell *)gestureCell {
    
}
- (void)gestureCellDidEndPan:(GGestureCell *)gestureCell {
    
}


@end
