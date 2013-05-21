//
//  GTextViewCell.m
//  GKitDemo
//
//  Created by Glare on 13-5-18.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GTextViewCell.h"
#import "GCore.h"

@implementation GTextViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _textView = [[GTextView alloc] init];
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubviewToFill:_textView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    if (![_textView isEditable] ||
        ![_textView isUserInteractionEnabled])
    {
        return;
    }
    
    if (selected)
    {
        if (![_textView isFirstResponder]) [_textView becomeFirstResponder];
        
    } else {
        
        if ([_textView isFirstResponder]) [_textView resignFirstResponder];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (_delegate &&
        [_delegate respondsToSelector:@selector(textViewCellShouldBeginEditing:)])
    {
        return [_delegate textViewCellShouldBeginEditing:self];
        
    } else {
        
        return YES;
    }
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (_delegate &&
        [_delegate respondsToSelector:@selector(textViewCellShouldEndEditing:)])
    {
        return [_delegate textViewCellShouldEndEditing:self];
        
    } else {
        
        return YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (_delegate &&
        [_delegate respondsToSelector:@selector(textViewCellDidBeginEditing:)])
    {
        [_delegate textViewCellDidBeginEditing:self];
    }
    
    if (self.selected == NO)
    {
		[self.tableView selectRowAtIndexPath:self.indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (_delegate &&
        [_delegate respondsToSelector:@selector(textViewCellDidEndEditing:)])
    {
        [_delegate textViewCellDidEndEditing:self];
    }
    
    if (self.selected == YES)
    {
        [self.tableView deselectRowAtIndexPath:self.indexPath animated:YES];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (_delegate &&
        [_delegate respondsToSelector:@selector(textViewCell:shouldChangeTextInRange:replacementText:)])
    {
        return [_delegate textViewCell:self shouldChangeTextInRange:range replacementText:text];
    } else {
        return YES;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (_delegate &&
        [_delegate respondsToSelector:@selector(textViewCellDidChange:)])
    {
        [_delegate textViewCellDidChange:self];
    }
	
	[_textView showOrHidePlaceHolderTextView];
}

- (void)textViewDidChangeSelection:(UITextView *)textView;
{
    if (_delegate &&
        [_delegate respondsToSelector:@selector(textViewCellDidChangeSelection:)])
    {
        [_delegate textViewCellDidChangeSelection:self];
    }
}

@end
