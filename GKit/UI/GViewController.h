//
//  GViewController.h
//  YouHuo
//
//  Created by Glare on 13-2-24.
//
//

#import <UIKit/UIKit.h>
#import "UIView+GKit.h"
@interface GViewController : UIViewController
@property (nonatomic, copy) void (^blockCallBack)(id);
@end
