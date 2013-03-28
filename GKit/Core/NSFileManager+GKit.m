//
//  NSFileManager+GKit.m
//  GKitDemo
//
//  Created by Hua Cao on 13-3-28.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "NSFileManager+GKit.h"
#import "UIApplication+GKit.h"
#import "UIDevice+GKit.h"
#import "NSString+GKit.h"
#import "GDebuggingTools.h"

@implementation NSFileManager (GKit)

///////////
+ (BOOL) createDiretoryWithName: (NSString *)directoryName
{
	NSURL *url = _GURLForDirectroyNamed(directoryName);
	if (url==nil) return NO;
	
	//Create directory
	NSError *error = nil;
	if (![[self defaultManager] createDirectoryAtURL: url
						 withIntermediateDirectories: YES
										  attributes: nil
											   error: &error])
	{
		GPRINTError(error);
		return NO;
	}
	
	return YES;
}

///////////
+ (BOOL) removeDiretoryWithName: (NSString *)directoryName
{
	NSURL *url = _GURLForDirectroyNamed(directoryName);
	if (url==nil) return YES;

	//Remove directory
	NSError *error = nil;
	if (![[self defaultManager] removeItemAtURL: url
										  error: &error])
	{
		GPRINTError(error);
		return NO;
	}
	
	return YES;
}

////////////////
+ (void) displayInfomationForDirectoryNamed: (NSString *)directoryName
{
	NSURL *url = _GURLForDirectroyNamed(directoryName);
	if (url==nil) return;

	NSError *error = nil;
	NSArray *array = [[self defaultManager] contentsOfDirectoryAtURL: url
										  includingPropertiesForKeys: nil
															 options:
					  NSDirectoryEnumerationSkipsSubdirectoryDescendants|
					  NSDirectoryEnumerationSkipsPackageDescendants|
					  NSDirectoryEnumerationSkipsHiddenFiles
															   error: &error];
	if (error) {
		GPRINTError(error);
		return;
	}
	
	GPRINT(@"count: %d\ncontents: %@",[array count],array);
}

//////////
+ (NSString *) uniqueItemName
{
	NSString *nameBase = [NSString stringWithFormat:@"%@%@%@",
						  [[UIDevice currentDevice] uniqueDeviceIdentifier],
						  [NSDate date],
						  [NSString stringWithUUID]];
	return [nameBase SHA1Sum];

}
/////////
+ (NSURL *) URLForItemNamed: (NSString *)name
				inDirectory: (NSString *)directoryName
{
	//
	NSURL *url = _GURLForDirectroyNamed(directoryName);
	if (url==nil) return nil;
	
	//
	if (GStringIsNil(name)) return nil;
	
	//
	return [url URLByAppendingPathComponent:name];
}
/////////
+ (BOOL) createItem: (NSData *)contents
		   withName: (NSString *)name
		inDirectory: (NSString *)directoryName
{
	//Create Directory
	if (![self createDiretoryWithName:directoryName]) {
		return NO;
	}
	
	//Item URL
	NSURL *itemURL = [self URLForItemNamed: name
							   inDirectory: directoryName];
	if (itemURL==nil) return NO;
	
	//Save Item
	if (![[self defaultManager] createFileAtPath:[itemURL absoluteString]
									   contents:contents
									 attributes:nil])
	{
		return NO;
	}
	
	return YES;
}
///////
+ (BOOL) removeItemNamed: (NSString *)name
			 inDirectory: (NSString *)directoryName
{
	//Item URL
	NSURL *itemURL = [self URLForItemNamed: name
							   inDirectory: directoryName];
	if (itemURL==nil) return YES;
	
	//Remove item
	NSError *error;
	if (![[self defaultManager] removeItemAtURL: itemURL
										  error: &error]) {
		GPRINTError(error);
		return NO;
	}
	
	return YES;
}

#pragma mark - Private
NSURL * _GURLForDirectroyNamed (NSString *directoryName)
{
	NSString *name = _GMakeNameUnique(directoryName);
	if (GStringIsNil(name)) return nil;
	return [GDocumentsDirectoryURL() URLByAppendingPathComponent:name];
}
NSString * _GMakeNameUnique (NSString *name)
{
	if (GStringIsNil(name)) return nil;
	return [name stringByAppendingString:@"(GKit)"];
}

@end
