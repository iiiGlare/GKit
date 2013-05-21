//
//  GDownloader.h
//  FakeCall
//
//  Created by Hua Cao on 12-9-23.
//
//

#import <Foundation/Foundation.h>

#define kGDownloaderDidFinishNotification @"GDownloaderDidFinishNotification"

@interface GDownloader : NSObject

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic) BOOL isShowError;

+ (void)downloadWithURLString:(NSString *)urlString
					 filePath:(NSString *)filePath;
+ (void)downloadWithURLString:(NSString *)urlString
					 filePath:(NSString *)filePath
					showError:(BOOL)showError;
@end
