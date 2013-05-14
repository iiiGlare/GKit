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
#import <AVFoundation/AVFoundation.h>

@class GCamera;
@protocol GCameraDelegate;

@interface AVCaptureVideoPreviewView : UIView
@end

@interface GCamera : NSObject
<AVCaptureVideoDataOutputSampleBufferDelegate>
{
	AVCaptureDevicePosition _currentPosition;
}

@property (nonatomic, weak) id<GCameraDelegate> delegate;

//
enum {
	GCaptureDevicePositionBack		= AVCaptureDevicePositionBack,
	GCaptureDevicePositionFront		= AVCaptureDevicePositionFront
};
typedef NSInteger GCaptureDevicePosition;

@property (nonatomic, readonly) GCaptureDevicePosition captureDevicePosition;

//
enum {
	GCaptureSessionPresetPhoto				= 1,
	GCaptureSessionPresetHigh				= 2,
	GCaptureSessionPresetMedium				= 3,
	GCaptureSessionPresetLow				= 4,
	GCaptureSessionPreset352x288			= 5,
	GCaptureSessionPreset640x480			= 6,
	GCaptureSessionPreset1280x720			= 7,
	GCaptureSessionPreset1920x1080			= 8,
	GCaptureSessionPresetiFrame960x540		= 9,
	GCaptureSessionPresetiFrame1280x720		= 10
};
typedef NSInteger GCaptureSessionPresetType;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *captureDevice;

@property (nonatomic, strong) UIView *focusView;
@property (nonatomic, strong) AVCaptureVideoPreviewView *previewView;

/**
 Create GCamera
 */
- (GCamera *)initWithSessionPreset: (GCaptureSessionPresetType)presetType
			 captureDevicePosition: (GCaptureDevicePosition)devicePosition;

- (void)startRunning;
- (void)stopRunning;

- (void)capturePictureWithCallBack:(void (^)(UIImage *picture))blockCallBack;

- (void)switchCaptureDevicePosition;

- (void)autoFocusAtPoint:(CGPoint)point;
- (void)continuousFocusAtPoint:(CGPoint)point;

@end

#pragma mark - GCameraDelegate
@protocol GCameraDelegate <NSObject>

@optional
- (void)camera:(GCamera *)camera didCapturePicture:(UIImage *)picture;

@end
