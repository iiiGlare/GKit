//
//  UIApplication+GKit.m
//  GKitDemo
//
//  Created by Glare on 13-2-12.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "UIApplication+GKit.h"

//////////////////////////////////////////////////////////////////////////////////
NSURL* GDocumentsDirectoryURL(void)
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//////////////////////////////////////////////////////////////////////////////////
NSURL* GCachesDirectoryURL(void)
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

//////////////////////////////////////////////////////////////////////////////////
NSURL* GDownloadsDirectoryURL(void)
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDownloadsDirectory inDomains:NSUserDomainMask] lastObject];
}

//////////////////////////////////////////////////////////////////////////////////
NSURL* GLibraryDirectoryURL(void)
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

//////////////////////////////////////////////////////////////////////////////////
NSURL* GApplicationSupportDirectoryURL(void)
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
}

//////////////////////////////////////////////////////////////////////////////////
UIViewController * GApplicationRootViewController(void)
{
    return [[[UIApplication sharedApplication] keyWindow] rootViewController];
}

@implementation UIApplication (GKit)

@end
