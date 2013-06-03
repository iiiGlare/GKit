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
@property (nonatomic, strong) NSMutableArray * componentTableViews;

@property (nonatomic, strong) NSMutableDictionary * textFontInfo;
@property (nonatomic, strong) NSMutableDictionary * textColorInfo;

@end

@implementation GPicker

#pragma mark - Setter / Getter
- (void)setBackgroundImage:(UIImage *)backgroundImage {
    
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = backgroundImage;
}

- (void)setIndicatorImage:(UIImage *)indicatorImage {
    
    _indicatorImage = indicatorImage;
    self.indicatorImageView.image = indicatorImage;
    [_indicatorImageView sizeToFit];
    _indicatorImageView.center = self.innerCenter;
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    
    _contentEdgeInsets = contentEdgeInsets;
    self.contentView.frame = CGRectMake(contentEdgeInsets.left,
                                        contentEdgeInsets.top,
                                        self.width-contentEdgeInsets.left-contentEdgeInsets.right,
                                        self.height-contentEdgeInsets.top-contentEdgeInsets.bottom);
}

- (void)setSeparatorLineImage:(UIImage *)separatorLineImage {
    
    _separatorLineImage = separatorLineImage;
    for (UIView * view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [(UIImageView *)view setImage:self.separatorLineImage];
        }
    }
}

- (void)setTextFont:(UIFont *)textFont forControlState:(UIControlState)controlState {
    
    [_textFontInfo setObject:textFont forKey:GNumberWithInteger(controlState)];
}

- (void)setTextColor:(UIColor *)textColor forControlState:(UIControlState)controlState {
    
    [_textColorInfo setObject:textColor forKey:GNumberWithInteger(controlState)];
}

- (UIFont *)textFontForControlState:(UIControlState)controlState {
    
    return [_textFontInfo objectForKey:GNumberWithInteger(controlState)];
}

- (UIColor *)textColorForControlState:(UIControlState)controlState {
    
    return [_textColorInfo objectForKey:GNumberWithInteger(controlState)];
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
    
    _componentTableViews = [NSMutableArray array];
    
    _textFontInfo = [NSMutableDictionary dictionary];
    [_textFontInfo setObject:[UIFont systemFontOfSize:15.0] forKey:GNumberWithInteger(UIControlStateNormal)];
    
    _textColorInfo = [NSMutableDictionary dictionary];
    [_textColorInfo setObject:[UIColor blackColor] forKey:GNumberWithInteger(UIControlStateNormal)];
    [_textColorInfo setObject:[UIColor whiteColor] forKey:GNumberWithInteger(UIControlStateSelected)];
    [_textColorInfo setObject:[UIColor grayColor] forKey:GNumberWithInteger(UIControlStateDisabled)];
    
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
    indicatorImageView.clipsToBounds = YES;
    [self addSubview:indicatorImageView];
    self.indicatorImageView = indicatorImageView;
}

- (void)reloadAllComponents
{
    // remove all subviews
    [self.contentView removeAllSubviewOfClass:[UIView class]];
    [_componentTableViews removeAllObjects];
    
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
        
        [tableView reloadData];
        
        [_componentTableViews addObject:tableView];
        
        componentX += componentWidth;
    }
    
}

- (void)reloadComponent:(NSInteger)component {
    
    [[_componentTableViews objectAtPosition:component] reloadData];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    
    [self scrollTableView:[_componentTableViews objectAtPosition:component] toRow:row animated:YES];
}

- (NSInteger)selectedRowInComponent:(NSInteger)component {
    
    return [self selectedRowInTableView:[_componentTableViews objectAtPosition:component]];
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_dataSource picker:self numberOfRowsInComponent:tableView.tag];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLabelCell * cell = [self cellForTableView:tableView atIndexPath:indexPath];
    
    [self configureCell:cell inTableView:tableView atIndexPath:indexPath];
    
    return cell;
}
- (GLabelCell *)cellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * CellIdentifier = @"GPickerCell";
    GLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.label.textAlignmentG = GTextAlignmentCenter;
        cell.label.textColor = [self textColorForControlState:UIControlStateNormal];
        cell.label.font = [self textFontForControlState:UIControlStateNormal];
    }
    return cell;
}

- (void)configureCell:(GLabelCell *)cell inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    if (_delegate &&
        [_delegate respondsToSelector:@selector(picker:titleForRow:forComponent:)]) {
        cell.label.text = [_delegate picker:self titleForRow:indexPath.row forComponent:tableView.tag];
    } else {
        cell.label.text = [NSString stringWithFormat:@"%d",indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_delegate &&
        [_delegate respondsToSelector:@selector(picker:rowHeightForComponent:)]) {
        return [_delegate picker:self rowHeightForComponent:tableView.tag];
    } else {
        return 44;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self scrollTableView:tableView toRow:indexPath.row animated:YES];
}

- (void)scrollViewDidScroll:(UITableView *)tableView {
    
    BOOL isIndicatorImageViewHasCells = NO;
    for (GLabelCell * cell in self.indicatorImageView.subviews) {
        if (cell.tag == tableView.tag) {
            isIndicatorImageViewHasCells = YES;
            break;
        }
    }
    
    CGFloat rowHeight = [self tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSInteger numberOfIndicatorImageViewCells = (NSInteger)(self.indicatorImageView.height/rowHeight) + 2;
    if (!isIndicatorImageViewHasCells) {
        for (NSInteger i=0; i<numberOfIndicatorImageViewCells; i++) {
            GLabelCell * cell = [self cellForTableView:nil atIndexPath:nil];
            cell.tag = tableView.tag;
            [self.indicatorImageView addSubview:cell];
        }
    }
    
    NSArray * indexPaths =
    [tableView indexPathsForRowsInRect:[tableView convertRect:self.indicatorImageView.frame
                                                     fromView:self.indicatorImageView.superview]];
    NSInteger i = 0;
    for (GLabelCell * cell in self.indicatorImageView.subviews) {
        if (cell.tag == tableView.tag) {
            if (i<[indexPaths count]) {
                NSIndexPath * indexPath = [indexPaths objectAtPosition:i];
                GLabelCell * cellForIndexPath = (GLabelCell *)[tableView cellForRowAtIndexPath:indexPath];
                CGRect rectForCell =
                [self.indicatorImageView convertRect:cellForIndexPath.frame fromView:cellForIndexPath.superview];
                cell.frame = rectForCell;
                cell.label.textColor = [self textColorForControlState:UIControlStateSelected];
                [self configureCell:cell inTableView:tableView atIndexPath:indexPath];
                cell.hidden = NO;
            } else {
                cell.hidden = YES;
            }
            i++;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UITableView *)tableView {
    
    NSInteger rowForOffset = [self selectedRowInTableView:tableView];
    
    [self scrollTableView:tableView toRow:rowForOffset animated:YES];
}

- (void)scrollTableView:(UITableView *)tableView toRow:(NSInteger)row animated:(BOOL)animated {
    
    CGFloat offsetForRow = [self offsetForRow:row inTableView:tableView];
    
    [tableView setContentOffset:CGPointMake(0, offsetForRow) animated:animated];
    
    if (_delegate &&
        [_delegate respondsToSelector:@selector(picker:didSelectRow:inComponent:)]) {
        [_delegate picker:self didSelectRow:row inComponent:tableView.tag];
    }
}

- (NSInteger)selectedRowInTableView:(UITableView *)tableView {
    
    CGFloat rowHeight = [self tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSInteger rowForOffset = ((self.contentView.height-rowHeight)/2 + tableView.contentOffset.y)/rowHeight + 0.5;
    return rowForOffset;
}

- (CGFloat)offsetForRow:(NSInteger)row inTableView:(UITableView *)tableView {
    
    CGFloat rowHeight = [self tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    CGFloat offsetForRow = row*rowHeight - (self.contentView.height-rowHeight)/2;
    return offsetForRow;
}


@end
