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

#import "GImageManager.h"
#import "NSFileManager+GKit.h"
#import "GMacros.h"

#import <AssetsLibrary/ALAssetsLibrary.h>

@implementation GImageManager

/////
+ (NSString *)uniqueImageName {
	return [NSFileManager uniqueItemName];
}

//////
+ (BOOL)saveImage:(UIImage *)image
         withName:(NSString *)name
      inDirectory:(NSString *)directoryName {
	return [NSFileManager createItem:UIImageJPEGRepresentation(image, 1.0)
							withName:name
						 inDirectory:directoryName];
}

//////
+ (BOOL)deleteImageNamed:(NSString *)name
             inDirectory:(NSString *)directoryName {
	return [NSFileManager removeItemNamed:name
							  inDirectory:directoryName];
}

//Find
+ (NSString *)pathForImageNamed:(NSString *)name
                    inDirectory:(NSString *)directoryName {
	return [[NSFileManager URLForItemNamed:name
							   inDirectory:directoryName] path];
}

+ (UIImage *)imageNamed:(NSString *)name
            inDirectory:(NSString *)directoryName {
    NSString * path = [self pathForImageNamed:name inDirectory:directoryName];
    UIImage * image = [[UIImage alloc] initWithContentsOfFile:path];
    return image;
}

//Local Library
+ (void)saveImageIntoLocalLibrary:(UIImage *)image
					 blockSucceed:(void (^)(void))blockSucceed
					  blockFailed:(void (^)(void))blockFailed {
	if (image==nil) return;
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
		[assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage
										orientation:(ALAssetOrientation)[image imageOrientation]
									completionBlock:^(NSURL *assetURL, NSError *error)
		 {
			 dispatch_sync(dispatch_get_main_queue(), ^{
				 if (error) {
					 GPRINTError(error);
                     if (blockFailed) {
                        blockFailed();
                     }
				 }else{
                     if (blockSucceed) {
                        blockSucceed();
                     }
				 }
			 });
		 }];
	});
}


@end
