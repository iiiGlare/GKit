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

#import <UIKit/UIKit.h>

@interface GImageManager : NSObject

//Name
+ (NSString *) uniqueImageName;

//Save
+ (BOOL) saveImage: (UIImage *)image
		  withName: (NSString *)name
	   inDirectory: (NSString *)directoryName;

//Delete
+ (BOOL) deleteImageNamed: (NSString *)name
			  inDirectory: (NSString *)directoryName;

//Find
+ (NSString *) pathForImageNamed: (NSString *)name
					 inDirectory: (NSString *)directoryName;
+ (UIImage *) imageNamed: (NSString *)name
			 inDirectory: (NSString *)directoryName;

//Local Library
+ (void) saveImageIntoLocalLibrary: (UIImage *)image
                      blockSucceed: (void (^)(void))blockSucceed
                       blockFailed: (void (^)(void))blockFailed;

@end
