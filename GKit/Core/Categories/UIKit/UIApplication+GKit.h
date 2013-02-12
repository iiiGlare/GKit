//
//  UIApplication+GKit.h
//  GKitDemo
//
//  Created by Glare on 13-2-12.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

/**
 * Returns the url to the application's Documents directory.
 */
NSURL* GDocumentsDirectoryURL(void);

/**
 * Returns the url to the application's Caches directory.
 */
NSURL* GCachesDirectoryURL(void);

/**
 * Returns the url to the application's Downloads directory.
 */
NSURL* GDownloadsDirectoryURL(void);

/**
 * Returns the url to the application's Library directory.
 */
NSURL* GLibraryDirectoryURL(void);

/**
 * Returns the url to the application's Support directory.
 */
NSURL* GApplicationSupportDirectoryURL(void);

@interface UIApplication (GKit)

@end
