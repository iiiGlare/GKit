/**
 * Copyright (c) 2012 Charles Powell
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

/**
 * Based heavily on AFPickerView by Fraerman Arkady
 * https://github.com/arkichek/AFPickerView
 * And CPPickerView by Charles Powell
 * https://github.com/cbpowell/CPPickerView.git
 */

//
//  GSinglePicker.m
//

#import "GSinglePicker.h"

@implementation GSinglePickerItem
@synthesize titleLabel;
- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		[self addSubview:label];
		self.titleLabel = label;
	}
	return self;
}
@end

@interface GSinglePicker ()
{
	BOOL _ignoreTap;
}

@end

@implementation GSinglePicker

@synthesize dataSource;
@synthesize delegate;
@synthesize contentView;
@synthesize glassImage, backgroundImage, shadowImage;
@synthesize selectedItem = currentIndex;
@synthesize itemFont = _itemFont;
@synthesize itemColor = _itemColor;
@synthesize supportFlow=_supportFlow,scrollVertical=_scrollVertical,showGlass=_showGlass,glassSize=_glassSize,peekInset=_peekInset;

#pragma mark - Custom getters/setters

- (void)setSelectedItem:(int)selectedItem
{
    if (selectedItem >= itemCount)
        selectedItem = itemCount-1;
	if (selectedItem < 0)
		selectedItem = 0;
    
    currentIndex = selectedItem;
    [self scrollToIndex:selectedItem animated:NO];
}




- (void)setItemFont:(UIFont *)itemFont
{
    _itemFont = itemFont;
    
    for (GSinglePickerItem *aItem in visibleViews)
    {
        aItem.titleLabel.font = _itemFont;
    }
    
	for (GSinglePickerItem *aItem in recycledViews)
    {
        aItem.titleLabel.font = _itemFont;
    }
}

- (void)setItemColor:(UIColor *)itemColor
{
    _itemColor = itemColor;
    
	for (GSinglePickerItem *aItem in visibleViews)
    {
        aItem.titleLabel.textColor = _itemColor;
    }
    
	for (GSinglePickerItem *aItem in recycledViews)
    {
        aItem.titleLabel.textColor = _itemColor;
    }
}

#pragma mark - Initialization
- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initialize];
	}
	return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
		[self initialize];
    }
    return self;
}

- (void)initialize
{
	// setup
	[self setup];
	
	// content
	self.contentView = [[UIScrollView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, self.peekInset)];
	self.contentView.clipsToBounds = NO;
	self.contentView.showsHorizontalScrollIndicator = NO;
	self.contentView.showsVerticalScrollIndicator = NO;
	self.contentView.pagingEnabled = NO;
	self.contentView.scrollsToTop = NO;
	self.contentView.delegate = self;
	[self addSubview:self.contentView];

	// Images
//	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
//		self.backgroundImage = [[UIImage imageNamed:@"wheelBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
//		self.glassImage = [[UIImage imageNamed:@"stretchableGlass"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];
//	} else {
//		self.backgroundImage = [[UIImage imageNamed:@"wheelBackground"] stretchableImageWithLeftCapWidth:0 topCapHeight:5];
//		self.glassImage = [[UIImage imageNamed:@"stretchableGlass"]  stretchableImageWithLeftCapWidth:1 topCapHeight:0];
//	}
//	self.shadowImage = [UIImage imageNamed:@"shadowOverlay"];
	
	
	// Rounded borders
//	self.layer.cornerRadius = 3.0f;
	self.clipsToBounds = YES;
//	self.layer.borderColor = [UIColor colorWithWhite:0.15 alpha:1.0].CGColor;
//	self.layer.borderWidth = 0.5f;
	
	//tap gesture
	UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
	[self addGestureRecognizer:tapGR];
}

- (void)setup
{
	self.backgroundColor = [UIColor clearColor];
    _itemFont = [UIFont boldSystemFontOfSize:24.0];
    _itemColor = [UIColor blackColor];
	_supportFlow = NO;
	_scrollVertical = NO;
    _showGlass = NO;
	_glassSize = self.bounds.size;
    _peekInset = UIEdgeInsetsMake(0, 0, 0, 0);
    currentIndex = 0;
    itemCount = 0;
    visibleViews = [[NSMutableSet alloc] init];
    recycledViews = [[NSMutableSet alloc] init];
	_ignoreTap = NO;
}

- (void)drawRect:(CGRect)rect {
    
    // Draw background
	if (self.backgroundImage) {
		[self.backgroundImage drawInRect:self.bounds];
	}
    
    // Draw super/UIScrollView
    [super drawRect:rect];
    
    // Draw shadow
	if (self.shadowImage) {
		[self.shadowImage drawInRect:self.bounds];
	}
    
    // Draw glass
    if (self.showGlass && self.glassImage) {
        [self.glassImage drawInRect:CGRectMake(self.frame.size.width / 2 - _glassSize.width/2, self.frame.size.height/2 - _glassSize.height/2,
											   _glassSize.width, _glassSize.height)];
    }
}
- (void)setSupportFlow:(BOOL)supportFlow
{
	if (_supportFlow != supportFlow) {
		_supportFlow = supportFlow;
		[self titleViews];
	}
}
- (void)setScrollVertical:(BOOL)scrollVertical
{
	if (_scrollVertical != scrollVertical) {
		_scrollVertical = scrollVertical;
		[self.contentView setNeedsDisplay];
	}
}

- (void)setShowGlass:(BOOL)doShowGlass {
    if (_showGlass != doShowGlass) {
        _showGlass = doShowGlass;
        [self setNeedsDisplay];
    }
}

- (void)setPeekInset:(UIEdgeInsets)aPeekInset {
    if (!UIEdgeInsetsEqualToEdgeInsets(_peekInset, aPeekInset)) {
        _peekInset = aPeekInset;
        self.contentView.frame = UIEdgeInsetsInsetRect(self.bounds, self.peekInset);
        [self.contentView setNeedsDisplay];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if ([self pointInside:point withEvent:event]) {
        return self.contentView;
    }
    
    return nil;
}

#pragma mark - 
- (void)tapped:(UITapGestureRecognizer *)gesture
{
	if (_ignoreTap) return;
	_ignoreTap = YES;
	CGPoint location = [gesture locationInView:gesture.view];
	
	if (!_scrollVertical) {
		if (location.x < (self.frame.size.width - _glassSize.width)/2) {
			//decrease
			[self selectItemAtIndex:self.selectedItem-1 animated:YES];
		}else if (location.x > (self.frame.size.width + _glassSize.width)/2){
			//increase
			[self selectItemAtIndex:self.selectedItem+1 animated:YES];
		}
	}else {
		if (location.y < (self.frame.size.height - _glassSize.height)/2) {
			//decrease
			[self selectItemAtIndex:self.selectedItem-1 animated:YES];
		}else if (location.y > (self.frame.size.height + _glassSize.height)/2){
			//increase
			[self selectItemAtIndex:self.selectedItem+1 animated:YES];
		}
	}
	if ([delegate respondsToSelector:@selector(pickerView:didSelectItem:)]) {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reportDidSelectItem) object:nil];
		[self performSelector:@selector(reportDidSelectItem) withObject:nil afterDelay:.3];
    }
	_ignoreTap = NO;
}
- (void)reportDidSelectItem
{
	[delegate pickerView:self didSelectItem:currentIndex];
}
#pragma mark - Data handling and interaction

- (void)reloadData
{
    // empty views
    currentIndex = 0;
    itemCount = 0;
    
    for (GSinglePickerItem *aItem in visibleViews)
        [aItem removeFromSuperview];
    
    for (GSinglePickerItem *aItem in recycledViews)
        [aItem removeFromSuperview];
    
    visibleViews = [[NSMutableSet alloc] init];
    recycledViews = [[NSMutableSet alloc] init];
    
    if ([dataSource respondsToSelector:@selector(numberOfItemsInPickerView:)]) {
        itemCount = [dataSource numberOfItemsInPickerView:self];
    } else {
        itemCount = 0;
    }
    
    [self scrollToIndex:0 animated:NO];
	if (!_scrollVertical) {
		self.contentView.contentSize = CGSizeMake(self.contentView.frame.size.width * itemCount, self.contentView.frame.size.height);
	}else{
		self.contentView.contentSize = CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height * itemCount);
	}
    
    [self titleViews];
}

- (void)determineCurrentItem
{
	if (!_scrollVertical) {
		CGFloat delta = self.contentView.contentOffset.x;
		currentIndex = round(delta / self.contentView.frame.size.width);
	}else{
		CGFloat delta = self.contentView.contentOffset.y;
		currentIndex = round(delta / self.contentView.frame.size.height);
	}
	[self reportDidSelectItem];
	
	if (self.contentView.pagingEnabled == NO) {
		[self scrollToIndex:currentIndex animated:YES];
	}
}

- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated {
	if (index >= itemCount)
        index = itemCount-1;
	if (index < 0)
		index = 0;
	currentIndex = index;
    [self scrollToIndex:index animated:animated];
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
	if (!_scrollVertical) {
		[self.contentView setContentOffset:CGPointMake(self.contentView.frame.size.width * index, 0.0) animated:animated];
	}else{
		[self.contentView setContentOffset:CGPointMake(0.0, self.contentView.frame.size.height * index) animated:animated];
	}
}




#pragma mark - recycle queue

- (GSinglePickerItem *)dequeueRecycledView
{
	GSinglePickerItem *aView = [recycledViews anyObject];
	
    if (aView)
        [recycledViews removeObject:aView];
    return aView;
}



- (BOOL)isDisplayingViewForIndex:(NSUInteger)index
{
	BOOL foundPage = NO;
    for (GSinglePickerItem *aView in visibleViews)
	{
        int viewIndex;
		if (!_scrollVertical) {
			viewIndex = aView.frame.origin.x / self.contentView.frame.size.width;
		}else{
			viewIndex = aView.frame.origin.y / self.contentView.frame.size.height;
		}
        if (viewIndex == index)
		{
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}


- (void)titleViews
{
    // Calculate which pages are visible
    CGRect visibleBounds = self.contentView.bounds;
    int currentViewIndex;
	if (!_scrollVertical) {
		currentViewIndex = floorf(self.contentView.contentOffset.x / self.contentView.frame.size.width);
	}else{
		currentViewIndex = floorf(self.contentView.contentOffset.y / self.contentView.frame.size.height);
	}
	
    int firstNeededViewIndex = currentViewIndex - 2;
    int lastNeededViewIndex  = currentViewIndex + 2;
    firstNeededViewIndex = MAX(firstNeededViewIndex, 0);
    lastNeededViewIndex  = MIN(lastNeededViewIndex, itemCount - 1);
	
    // Recycle no-longer-visible pages
	for (GSinglePickerItem *aView in visibleViews)
    {
        int viewIndex;
		if (!_scrollVertical) {
			viewIndex = aView.frame.origin.x / visibleBounds.size.width - 2;
		}else{
			viewIndex = aView.frame.origin.y / visibleBounds.size.height - 2;
		}
        if (viewIndex < firstNeededViewIndex || viewIndex > lastNeededViewIndex)
        {
            [recycledViews addObject:aView];
            [aView removeFromSuperview];
        }
    }
    
    [visibleViews minusSet:recycledViews];
    
    // add missing pages
	for (int index = firstNeededViewIndex; index <= lastNeededViewIndex; index++)
	{
        if (![self isDisplayingViewForIndex:index])
		{
            GSinglePickerItem *itemView = [self dequeueRecycledView];
			if (itemView == nil)
            {
				itemView = [[GSinglePickerItem alloc] initWithFrame:CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
				itemView.backgroundColor = [UIColor clearColor];
                itemView.titleLabel.backgroundColor = [UIColor clearColor];
                itemView.titleLabel.font = self.itemFont;
                itemView.titleLabel.textColor = self.itemColor;
                itemView.titleLabel.textAlignment = UITextAlignmentCenter;
            }
            
            [self configureView:itemView atIndex:index];
            [self.contentView addSubview:itemView];
            [visibleViews addObject:itemView];
        }
    }
	
	//support flow
	for (GSinglePickerItem *aItem in visibleViews) {
		CGFloat scale = 1.0;
		if (_supportFlow)
		{
			CGFloat offset = 0;
			if (!_scrollVertical) {
				offset = ABS(aItem.frame.origin.x - self.contentView.contentOffset.x);
				scale = MAX(1.0 - offset/self.contentView.frame.size.width, 0.5);
			}else{
				offset = ABS(aItem.frame.origin.y - self.contentView.contentOffset.y);
				scale = MAX(1.0 - offset/self.contentView.frame.size.height, 0.5);
			}
		}
		aItem.titleLabel.transform = CGAffineTransformMakeScale(scale, scale);
	}
}




- (void)configureView:(GSinglePickerItem *)view atIndex:(NSUInteger)index
{
    GSinglePickerItem *item = view;
    
    if ([dataSource respondsToSelector:@selector(pickerView:titleForItem:)]) {
        item.titleLabel.text = [dataSource pickerView:self titleForItem:index];
    }
    
    CGRect frame = item.frame;
	if (!_scrollVertical) {
		frame.origin.x = self.contentView.frame.size.width * index;
	}else{
		frame.origin.y = self.contentView.frame.size.height * index;
	}
    item.frame = frame;
}




#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self titleViews];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (!decelerate) {
		[self determineCurrentItem];
	}
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(determineCurrentItem) object:nil];
    [self determineCurrentItem];
}

@end
