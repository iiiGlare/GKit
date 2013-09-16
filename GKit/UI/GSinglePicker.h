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
//  GSinglePicker.h
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@protocol GSinglePickerDataSource;
@protocol GSinglePickerDelegate;

@interface GSinglePickerItem : UIView
@property (nonatomic, weak) UILabel *titleLabel;
@end


@interface GSinglePicker : UIView <UIScrollViewDelegate>
{
    __weak id <GSinglePickerDataSource> dataSource;
    __weak id <GSinglePickerDelegate> delegate;
    UIScrollView *contentView;
    UIImageView *glassView;
    
    int currentIndex;
    int itemCount;
    
    // recycling
    NSMutableSet *recycledViews;
    NSMutableSet *visibleViews;
}

// Datasource and delegate
@property (nonatomic, weak) IBOutlet id <GSinglePickerDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id <GSinglePickerDelegate> delegate;
// Views
@property (nonatomic, strong) UIScrollView * contentView;
@property (nonatomic, strong) UIImage * backgroundImage;
@property (nonatomic, strong) UIImage * glassImage;
@property (nonatomic, strong) UIImage * shadowImage;
// Current status
@property (nonatomic, assign) int selectedItem;
// Configuration
@property (nonatomic, assign) BOOL supportFlow;
@property (nonatomic, assign) BOOL scrollVertical;
@property (nonatomic, strong) UIFont * itemFont;
@property (nonatomic, strong) UIColor * itemColor;
@property (nonatomic, assign) BOOL showGlass;
@property (nonatomic, assign) CGSize glassSize;
@property (nonatomic, assign) UIEdgeInsets peekInset;


- (void) setup;
- (void) reloadData;
//- (void)determineCurrentItem;
- (void) selectItemAtIndex:(NSInteger)index animated:(BOOL)animated;

// recycle queue
- (GSinglePickerItem *) dequeueRecycledView;
- (BOOL) isDisplayingViewForIndex:(NSUInteger)index;
- (void) titleViews;
- (void) configureView:(UIView *)view atIndex:(NSUInteger)index;

@end



@protocol GSinglePickerDataSource <NSObject>

- (NSInteger) numberOfItemsInPickerView:(GSinglePicker *)pickerView;
- (NSString *) pickerView:(GSinglePicker *)pickerView titleForItem:(NSInteger)item;

@end



@protocol GSinglePickerDelegate <NSObject>

- (void) pickerView:(GSinglePicker *)pickerView didSelectItem:(NSInteger)item;

@end