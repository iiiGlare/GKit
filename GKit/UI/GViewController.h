//
//  GViewController.h
//  YouHuo
//
//  Created by Glare on 13-2-24.
//
//

#import <UIKit/UIKit.h>

@interface GViewController : UIViewController
@property (nonatomic, copy) void (^blockCallBack)(id);
@end
