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
//  GPickerView.h
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@protocol GPickerViewDataSource;
@protocol GPickerViewDelegate;

@interface GPickerItem : UIView
@property (nonatomic, unsafe_unretained) UILabel *titleLabel;
@end


@interface GPickerView : UIView <UIScrollViewDelegate>
{
    __unsafe_unretained id <GPickerViewDataSource> dataSource;
    __unsafe_unretained id <GPickerViewDelegate> delegate;
    UIScrollView *contentView;
    UIImageView *glassView;
    
    int currentIndex;
    int itemCount;
    
    // recycling
    NSMutableSet *recycledViews;
    NSMutableSet *visibleViews;
}

// Datasource and delegate
@property (nonatomic, unsafe_unretained) IBOutlet id <GPickerViewDataSource> dataSource;
@property (nonatomic, unsafe_unretained) IBOutlet id <GPickerViewDelegate> delegate;
// Views
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIImage *glassImage;
@property (nonatomic, strong) UIImage *shadowImage;
// Current status
@property (nonatomic, unsafe_unretained) int selectedItem;
// Configuration
@property (nonatomic) BOOL supportFlow;
@property (nonatomic) BOOL scrollVertical;
@property (nonatomic, strong) UIFont *itemFont;
@property (nonatomic, strong) UIColor *itemColor;
@property (nonatomic) BOOL showGlass;
@property (nonatomic) CGSize glassSize;
@property (nonatomic) UIEdgeInsets peekInset;


- (void)setup;
- (void)reloadData;
//- (void)determineCurrentItem;
- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated;

// recycle queue
- (GPickerItem *)dequeueRecycledView;
- (BOOL)isDisplayingViewForIndex:(NSUInteger)index;
- (void)titleViews;
- (void)configureView:(UIView *)view atIndex:(NSUInteger)index;

@end



@protocol GPickerViewDataSource <NSObject>

- (NSInteger)numberOfItemsInPickerView:(GPickerView *)pickerView;
- (NSString *)pickerView:(GPickerView *)pickerView titleForItem:(NSInteger)item;

@end



@protocol GPickerViewDelegate <NSObject>

- (void)pickerView:(GPickerView *)pickerView didSelectItem:(NSInteger)item;

@end