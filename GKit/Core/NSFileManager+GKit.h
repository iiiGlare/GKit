//
//  NSFileManager+GKit.h
//  GKitDemo
//
//  Created by Hua Cao on 13-3-28.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (GKit)

#pragma mark - Directory
//create diretory
+ (NSURL *) createDiretoryWithName: (NSString *)directoryName;
//remove directory
+ (BOOL) removeDiretoryWithName: (NSString *)directoryName;
//show directory infomation
+ (void) displayInfomationForDirectoryNamed: (NSString *)directoryName;

#pragma mark - Item
//Unique Item Name
+ (NSString *) uniqueItemName;
//item Path
+ (NSURL *) URLForItemNamed: (NSString *)name
				inDirectory: (NSString *)directoryName;
//Save Item
+ (BOOL) createItem: (NSData *)contents
		   withName: (NSString *)name
		inDirectory: (NSString *)directoryName;
//Delete Item
+ (BOOL) removeItemNamed: (NSString *)name
			 inDirectory: (NSString *)directoryName;

@end
