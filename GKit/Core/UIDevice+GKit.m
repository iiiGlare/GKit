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

#import "UIDevice+GKit.h"
#import "NSString+GKit.h"

NSString * const G_OS_2_0 = @"2.0";
NSString * const G_OS_2_1 = @"2.1";
NSString * const G_OS_2_2 = @"2.2";
NSString * const G_OS_3_0 = @"3.0";
NSString * const G_OS_3_1 = @"3.1";
NSString * const G_OS_3_2 = @"3.2";
NSString * const G_OS_4_0 = @"4.0";
NSString * const G_OS_4_1 = @"4.1";
NSString * const G_OS_4_2 = @"4.2";
NSString * const G_OS_4_3 = @"4.3";
NSString * const G_OS_5_0 = @"5.0";
NSString * const G_OS_5_1 = @"5.1";
NSString * const G_OS_6_0 = @"6.0";
NSString * const G_OS_6_1 = @"6.1";
NSString * const G_OS_7_0 = @"7.0";

@implementation UIDevice (GKit)

//////////////////////////////////////////////////////////////////////////////////
+ (BOOL) isPad {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

+ (BOOL) isPhone {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

+ (BOOL) isPhone5 {
    return ([UIDevice isPhone] && [[UIScreen mainScreen] bounds].size.height == 568.0f);
}

//////////////////////////////////////////////////////////////////////////////////
+ (BOOL) isRetinaDisplay{
    return ([UIScreen instancesRespondToSelector:@selector(scale)] &&
            [[UIScreen mainScreen] scale] == 2.0);
}

//////////////////////////////////////////////////////////////////////////////////
+ (BOOL) isOSVersionHigherThan:(NSString *)minVersion {
    return [UIDevice isOSVersionHigherThanVersion:minVersion includeEqual:NO];
}
+ (BOOL) isOSVersionHigherThanOrEqualTo:(NSString *)minVersion {
    return [UIDevice isOSVersionHigherThanVersion:minVersion includeEqual:YES];
}
+ (BOOL) isOSVersionHigherThanVersion:(NSString *)minVersion includeEqual:(BOOL)isInclude
{
	NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
	NSComparisonResult comparisonResult = [sysVersion compare:minVersion];
	if (comparisonResult==NSOrderedDescending||(isInclude && comparisonResult==NSOrderedSame)) {
		return YES;
	}else{
		return NO;
	}
}

//////////////////////////////////////////////////////////////////////////////////
+ (BOOL) isOSVersionLowerThan:(NSString *)maxVersion {
    return [UIDevice isOSVersionLowerThanVersion:maxVersion includeEqual:NO];
}
+ (BOOL) isOSVersionLowerThanOrEqualTo:(NSString *)maxVersion {
    return [UIDevice isOSVersionLowerThanVersion:maxVersion includeEqual:YES];
}
+ (BOOL) isOSVersionLowerThanVersion:(NSString *)maxVersion includeEqual:(BOOL)isInclude
{
	NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
	NSComparisonResult comparisonResult = [sysVersion compare:maxVersion];
	if (comparisonResult==NSOrderedAscending||(isInclude && comparisonResult==NSOrderedSame)) {
		return YES;
	}else{
		return NO;
	}
}

@end

#pragma mark - 
//
//  UIDevice(Identifier).m
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface UIDevice(Private)

- (NSString *) macaddress;

@end

@implementation UIDevice (IdentifierAddition)

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
- (NSString *) macaddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public Methods

- (NSString *) uniqueDeviceIdentifier{
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
    NSString *uniqueIdentifier = [stringToHash MD5Sum];
    
    return uniqueIdentifier;
}

- (NSString *) uniqueGlobalDeviceIdentifier{
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    NSString *uniqueIdentifier = [macaddress MD5Sum];
    
    return uniqueIdentifier;
}

@end
