//
//  GPicker.m
//  GKitDemo
//
//  Created by Hua Cao on 13-5-31.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GPicker.h"
#import "GCore.h"
#import "GLabelCell.h"
@interface GPicker ()
<
 UITableViewDataSource, UITableViewDelegate
>

@property (nonatomic, weak) UIImageView * backgroundImageView;
@property (nonatomic, weak) UIImageView * indicatorImageView;
@property (nonatomic, weak) UIView * contentView;
@end

@implementation GPicker

#pragma mark - Setter
- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = backgroundImage;
}
- (void)setIndicatorImage:(UIImage *)indicatorImage
{
    _indicatorImage = indicatorImage;
    self.indicatorImageView.image = indicatorImage;
    [_indicatorImageView sizeToFit];
    _indicatorImageView.center = self.innerCenter;
}
- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
{
    _contentEdgeInsets = contentEdgeInsets;
    self.contentView.frame = CGRectMake(contentEdgeInsets.left,
                                        contentEdgeInsets.top,
                                        self.width-contentEdgeInsets.left-contentEdgeInsets.right,
                                        self.height-contentEdgeInsets.top-contentEdgeInsets.bottom);
}
- (void)setSeparatorLineImage:(UIImage *)separatorLineImage
{
    _separatorLineImage = separatorLineImage;
    for (UIView * view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [(UIImageView *)view setImage:self.separatorLineImage];
        }
    }
}
#pragma mark -
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self customInitialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self customInitialize];
    }
    return self;
}

- (void)customInitialize
{
    _contentEdgeInsets = UIEdgeInsetsZero;
    _separatorLineSize = CGSizeMake(1, self.height);
    
    // background image view
    UIImageView * backgroundImageView = [[UIImageView alloc] init];
    [self addSubviewToFill:backgroundImageView];
    self.backgroundImageView = backgroundImageView;
    
    // content view
    UIView * contentView = [[UIView alloc] init];
    [self addSubviewToFill:contentView];
    self.contentView = contentView;
    
    // indicator image view
    UIImageView * indicatorImageView = [[UIImageView alloc] init];
    indicatorImageView.autoresizingMask = GViewAutoresizingFlexibleMargins;
    [self addSubview:indicatorImageView];
    self.indicatorImageView = indicatorImageView;
}

- (void)reloadData
{
    // remove all subviews
    [self.contentView removeAllSubviewOfClass:[UIView class]];
    
    // 
    NSInteger numberOfComponents = [_dataSource numberOfComponentsInPicker:self];
    CGFloat componentX = 0;
    CGFloat componentY = 0;
    CGFloat componentWidth = 0;
    CGFloat componentHeight = self.contentView.height;
    for (NSInteger i=0; i<numberOfComponents; i++) {
        
        
        if (_delegate &&
            [_delegate respondsToSelector:@selector(picker:widthForComponent:)]) {
            componentWidth = [_delegate picker:self widthForComponent:i];
        } else {
            componentWidth = self.contentView.width/numberOfComponents;
        }
        
        UITableView * tableView = [[UITableView alloc] initWithFrame:
                                   CGRectMake(componentX, componentY, componentWidth, componentHeight)];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.tag = i;
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.contentView addSubview:tableView];
        [self.contentView sendSubviewToBack:tableView];
        
        CGFloat rowHeight = [self tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        tableView.contentInset = UIEdgeInsetsMake((componentHeight-rowHeight)/2, 0,
                                                  (componentHeight-rowHeight)/2, 0);
        
        if (i>0) {
            UIImageView * separatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _separatorLineSize.width, _separatorLineSize.height)];
            separatorLineImageView.image = self.separatorLineImage;
            separatorLineImageView.center = CGPointMake(componentX, componentHeight/2);
            [self.contentView addSubview:separatorLineImageView];
        }
        
        componentX += componentWidth;
    }
    
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource picker:self numberOfRowsInComponent:tableView.tag];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"GPickerCell";
    GLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.label.textAlignmentG = GTextAlignmentCenter;
    }
    if (_delegate &&
        [_delegate respondsToSelector:@selector(picker:titleForRow:forComponent:)]) {
        cell.label.text = [_delegate picker:self titleForRow:indexPath.row forComponent:tableView.tag];
    } else {
        cell.label.text = [NSString stringWithFormat:@"%d",indexPath.row];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate &&
        [_delegate respondsToSelector:@selector(picker:rowHeightForComponent:)]) {
        return [_delegate picker:self rowHeightForComponent:tableView.tag];
    } else {
        return 44;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView scrollToRow:indexPath.row];
}

- (void)scrollViewDidEndDecelerating:(UITableView *)tableView
{
    CGFloat rowHeight = [self tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSInteger rowForOffset = ((self.contentView.height-rowHeight)/2 + tableView.contentOffset.y)/rowHeight + 0.5;
    [self tableView:tableView scrollToRow:rowForOffset];
}

- (void)tableView:(UITableView *)tableView scrollToRow:(NSInteger)row
{
    CGFloat rowHeight = [self tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    CGFloat rowOffset = row * rowHeight - (self.contentView.height-rowHeight)/2;
    [tableView setContentOffset:CGPointMake(0, rowOffset) animated:YES];
    
    if (_delegate &&
        [_delegate respondsToSelector:@selector(picker:didSelectRow:inComponent:)]) {
        [_delegate picker:self didSelectRow:row inComponent:tableView.tag];
    }
}
@end
