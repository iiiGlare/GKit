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

- (void)dealloc {
    _textView.delegate = nil;
}

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

//
#pragma mark - Caculate Cell Height
+ (GTextView *)sharedTextView
{
	static GTextView * sharedTextView;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedTextView = [[GTextView alloc] init];
	});
	return sharedTextView;
}
+ (CGFloat)heightForTitle:(NSString *)title withFont:(UIFont *)font width:(CGFloat)width
{
	GTextView *sharedTextView = [GTextViewCell sharedTextView];
    sharedTextView.font = font;
	sharedTextView.frame = CGRectMake(0, 0, width, 44);
	sharedTextView.text = title;
	[sharedTextView sizeToFit];
	return sharedTextView.contentSize.height;
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
		UITableView * tableView = [self tableView];
		NSIndexPath * indexPath = [self indexPath];
		
		CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
		CGRect visibleRect = CGRectMake(0, tableView.contentOffset.y, tableView.width, tableView.height-tableView.contentInset.bottom);
		[tableView selectRowAtIndexPath: indexPath
							   animated: YES
						 scrollPosition: (CGRectContainsRect(visibleRect, rect)?UITableViewScrollPositionNone:UITableViewScrollPositionBottom)];
		
		if (tableView.delegate &&
			[tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
			
			[tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
		}
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
		UITableView * tableView = [self tableView];
		NSIndexPath * indexPath = [self indexPath];

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
		
		if (tableView.delegate &&
			[tableView.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
			
			[tableView.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
		}
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
