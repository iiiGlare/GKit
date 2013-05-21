//
//  GTextFieldCell.m
//  GKitDemo
//
//  Created by Glare on 13-5-18.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GTextFieldCell.h"
#import "GCore.h"

@implementation GTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _textField = [[GTextField alloc] init];
        _textField.delegate = self;
        _textField.backgroundColor = [UIColor clearColor];
        _textField.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubviewToFill:_textField];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    if (![_textField isUserInteractionEnabled] ||
        ![_textField isEnabled])
    {
        return;
    }
    
    if (selected)
    {
        if (![_textField isFirstResponder]) [_textField becomeFirstResponder];
        
    } else {
        
        if ([_textField isFirstResponder]) [_textField resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_delegate &&
        [_delegate respondsToSelector:@selector(textFieldCellShouldBeginEditing:)])
    {
        return [_delegate textFieldCellShouldBeginEditing:self];
        
    } else {
        
        return YES;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_delegate &&
        [_delegate respondsToSelector:@selector(textFieldCellDidBeginEditing:)])
    {
        [_delegate textFieldCellDidBeginEditing:self];
    }
    
    if (self.selected == NO)
    {
        [self.tableView selectRowAtIndexPath:self.indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (_delegate &&
        [_delegate respondsToSelector:@selector(textFieldCellShouldEndEditing:)])
    {
        return [_delegate textFieldCellShouldEndEditing:self];
    } else {
        return YES;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_delegate &&
        [_delegate respondsToSelector:@selector(textFieldCellDidEndEditing:)])
    {
        [_delegate textFieldCellDidEndEditing:self];
    }
    
    if (self.selected == YES)
    {
        [self.tableView deselectRowAtIndexPath:self.indexPath animated:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_delegate &&
        [_delegate respondsToSelector:@selector(textFieldCell:shouldChangeCharactersInRange:replacementString:)])
    {
        return [_delegate textFieldCell:self shouldChangeCharactersInRange:range replacementString:string];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (_delegate &&
        [_delegate respondsToSelector:@selector(textFieldCellShouldClear:)])
    {
        return [_delegate textFieldCellShouldClear:self];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_delegate &&
        [_delegate respondsToSelector:@selector(textFieldCellShouldReturn:)])
    {
        return [_delegate textFieldCellShouldReturn:self];
    } else {
        return YES;
    }
}

@end
