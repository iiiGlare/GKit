//
// Created by Cao Hua <glare.ch@gmail.com> on 2012
// Copyright 2012 GKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "UIApplication+GKit.h"
#import "NSArray+GKit.h"

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
    return [GApplicationWindow() rootViewController];
}

//////////////////////////////////////////////////////////////////////////////////
UIWindow * GApplicationWindow(void) {
	
	return [[[UIApplication sharedApplication] delegate] window];
}


@implementation UIApplication (GKit)

@end
