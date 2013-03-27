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

#import "GCamera.h"

static void *AVCamFocusModeObserverContext = &AVCamFocusModeObserverContext;


@implementation AVCaptureVideoPreviewView
- (void)layoutSubviews
{
	for (CALayer *layer in self.layer.sublayers) {
		if ([layer isKindOfClass:[AVCaptureVideoPreviewLayer class]]) {
			layer.frame = self.bounds;
		}
	}
}

@end


@interface GCamera ()
- (BOOL)_setupCamera:(NSString *)preset;
- (void)_removeAllInputs;
- (BOOL)_addCaputreDeviceWithPosition:(int)position;
AVCaptureConnection *_VideoConnectionFromOutput(AVCaptureOutput *output, NSString *type);
@end

@implementation GCamera

#pragma mark Init & Memory Management

- (void)dealloc
{
	[self removeObserver:self forKeyPath:@"self.captureDevice.focusMode"];
	[_session stopRunning];
}

- (GCamera *)initWithSessionPreset: (GCaptureSessionPresetType)presetType
			 captureDevicePosition: (GCaptureDevicePosition)devicePosition
{
	self = [super init];
	if (self) {
		
		//Position
		_currentPosition = (AVCaptureDevicePosition)devicePosition;
		if (0==_currentPosition) _currentPosition = AVCaptureDevicePositionBack;
		
		//Setup Camera
		NSString *preset = nil;
		switch (presetType) {
			case GCaptureSessionPresetPhoto:
				preset = AVCaptureSessionPresetPhoto;
				break;
			case GCaptureSessionPresetHigh:
				preset = AVCaptureSessionPresetHigh;
				break;
			case GCaptureSessionPresetMedium:
				preset = AVCaptureSessionPresetMedium;
				break;
			case GCaptureSessionPresetLow:
				preset = AVCaptureSessionPresetLow;
				break;
			case GCaptureSessionPreset352x288:
				preset = AVCaptureSessionPreset352x288;
				break;
			case GCaptureSessionPreset640x480:
				preset = AVCaptureSessionPreset640x480;
				break;
			case GCaptureSessionPreset1280x720:
				preset = AVCaptureSessionPreset1280x720;
				break;
			case GCaptureSessionPreset1920x1080:
				preset = AVCaptureSessionPreset1920x1080;
				break;
			case GCaptureSessionPresetiFrame960x540:
				preset = AVCaptureSessionPresetiFrame960x540;
				break;
			case GCaptureSessionPresetiFrame1280x720:
				preset = AVCaptureSessionPresetiFrame1280x720;
				break;
			default:
				break;
		}
		
		if (preset==nil || [self _setupCamera:preset]==NO) {
			return nil;
		}
		
		//Focus View
		_focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
		_focusView.backgroundColor = [UIColor clearColor];
		_focusView.layer.borderColor = [UIColor whiteColor].CGColor;
		_focusView.layer.borderWidth = 2.0;
		_focusView.hidden = YES;
		[self.previewView addSubview:_focusView];
		[self addObserver: self
			   forKeyPath: @"self.captureDevice.focusMode"
				  options: NSKeyValueObservingOptionNew
				  context: AVCamFocusModeObserverContext];
	}
	return self;
}

- (BOOL)_setupCamera:(NSString *)preset
{
	//Add Camera
    self.session = [[AVCaptureSession alloc] init];
    if ([_session canSetSessionPreset:preset]) {
        _session.sessionPreset = preset;
        
        //input
        if (![self _addCaputreDeviceWithPosition:_currentPosition]) {
            // Handle the error appropriately.
			return NO;
        }
        
        //output
		//        AVCaptureVideoDataOutput *output = [[[AVCaptureVideoDataOutput alloc] init] autorelease];
		//        {
		//            output.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
		//                                                               forKey:(id)kCVPixelBufferPixelFormatTypeKey];
		//            //queue
		//            dispatch_queue_t queue = dispatch_queue_create("MyQueue", NULL);
		//            [output setSampleBufferDelegate:self queue:queue];
		//            dispatch_release(queue);
		//        }
        AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [stillImageOutput setOutputSettings:outputSettings];
        [_session addOutput:stillImageOutput];
		
        //AVCaptureConnection
        AVCaptureConnection *videoConnection = _VideoConnectionFromOutput(stillImageOutput, AVMediaTypeVideo);
        [videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
        
        //display
		AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
		previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
		AVCaptureVideoPreviewView *previewView = [[AVCaptureVideoPreviewView alloc] initWithFrame:previewLayer.bounds];
		// Add a single tap gesture to focus on the point tapped, then lock focus
		UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToAutoFocus:)];
		[singleTap setNumberOfTapsRequired:1];
		[previewView addGestureRecognizer:singleTap];
		// Add a double tap gesture to reset the focus mode to continuous auto focus
		//		UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToContinouslyAutoFocus:)];
		//		[doubleTap setNumberOfTapsRequired:2];
		//		[singleTap requireGestureRecognizerToFail:doubleTap];
		//		[previewView addGestureRecognizer:doubleTap];
		//		[doubleTap release];
		[previewView.layer addSublayer:previewLayer];
		self.previewView = previewView;
		
		return YES;
    }
	return NO;
}

- (BOOL)_addCaputreDeviceWithPosition:(int)position
{
	//find device at position
	AVCaptureDevice *device = nil;
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	for (NSUInteger idx=0; idx<[devices count]; idx++) {
		AVCaptureDevice *obj = [devices objectAtIndex:idx];
		if (position == obj.position){
			device = obj;
			break;
		}
	}
	if (!device) {
		return NO;
	}
	
	//Capture device settings
	//	GPRINT(@"focus mode:%d\nexposure mode:%d\nwhite balance mode:%d\n",device.focusMode,device.exposureMode,device.whiteBalanceMode);
	[self continuousFocusAtPoint:CGPointMake(.5f, .5f)];
	
	NSError *error = nil;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice: device
																		error: &error];
	if (!input) {
		// Handle the error appropriately.
		return NO;
	}
	self.captureDevice = device;
	_currentPosition = position;
	[_session addInput:input];
	return YES;
}

AVCaptureConnection *_VideoConnectionFromOutput(AVCaptureOutput *output, NSString *type)
{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in output.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:type]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    return videoConnection;
}

- (void)_removeAllInputs
{
	while (_session.inputs.count>0) {
		AVCaptureInput *obj = [_session.inputs objectAtIndex:0];
		[_session removeInput:obj];
	}
}


#pragma mark - Getter/Setter
- (GCaptureDevicePosition)captureDevicePosition
{
	return _currentPosition;
}

#pragma mark - Actions

- (void)startRunning
{
	if (![_session isRunning]) {
		[_session startRunning];
	}
}

- (void)stopRunning
{
	if ([_session isRunning]) {
		[_session stopRunning];
	}
}

- (void)capturePicture
{
    for (AVCaptureOutput *output in [self.session outputs]) {
        if ([[output class] isSubclassOfClass:[AVCaptureStillImageOutput class]]) {
            AVCaptureStillImageOutput *stillImageOutput = (AVCaptureStillImageOutput *)output;
            AVCaptureConnection *videoConnection = _VideoConnectionFromOutput(stillImageOutput, AVMediaTypeVideo);
			
			//Available in iOS 4.0 and later.
            [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error){
				if (!error) {
					NSData *pictureData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
					UIImage *picture = [UIImage imageWithData:pictureData];
					UIImage *newPicture = nil;
					//如果是前置摄像头拍摄，则左右翻转图像
					if (AVCaptureDevicePositionFront==_currentPosition)
					{
						UIGraphicsBeginImageContext(picture.size);
						CGContextRef context = UIGraphicsGetCurrentContext();
						CGContextConcatCTM(context, CGAffineTransformMake(-1, 0, 0, 1, picture.size.width, 0));
						[picture drawInRect:CGRectMake(0, 0, picture.size.width, picture.size.height)];
						newPicture = UIGraphicsGetImageFromCurrentImageContext();
						UIGraphicsEndImageContext();
					}else {
						newPicture = picture;
					}
					if (newPicture && _delegate && [_delegate respondsToSelector:@selector(gCamera:didCapturePicture:)]) {
						[_delegate gCamera:self didCapturePicture:newPicture];
					}
				}
            }];
			break;
        }
    }
}

- (void)switchCaptureDevicePosition
{
	[self stopRunning];
	[_session beginConfiguration];
	[self _removeAllInputs];
	[self _addCaputreDeviceWithPosition:(_currentPosition%2+1)];
	[_session commitConfiguration];
	[self startRunning];
}

// Perform an auto focus at the specified point. The focus mode will automatically change to locked once the auto focus is complete.
- (void) autoFocusAtPoint:(CGPoint)point
{
	NSError *error;
	GLOG(@"x:%f,y:%f",point.x,point.y);
	if ([_captureDevice lockForConfiguration:&error]) {
		
		if ([_captureDevice isFocusPointOfInterestSupported] &&
			[_captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus])
		{
			[_captureDevice setFocusPointOfInterest:point];
			[_captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
		}
		
		if ([_captureDevice isExposurePointOfInterestSupported] &&
			[_captureDevice isExposureModeSupported:AVCaptureFocusModeContinuousAutoFocus])
		{
			[_captureDevice setExposurePointOfInterest:point];
			[_captureDevice setExposureMode:AVCaptureFocusModeContinuousAutoFocus];
		}
		
		[_captureDevice unlockForConfiguration];
	}
}

// Switch to continuous auto focus mode at the specified point
- (void) continuousFocusAtPoint: (CGPoint)point
{
	NSError *error;
	if ([_captureDevice lockForConfiguration:&error]) {
		
		if ([_captureDevice isFocusPointOfInterestSupported] &&
			[_captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
		{
			[_captureDevice setFocusPointOfInterest:point];
			[_captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
		}
		
		if ([_captureDevice isExposurePointOfInterestSupported] &&
			[_captureDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
		{
			[_captureDevice setExposurePointOfInterest:point];
			[_captureDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
		}
		
		[_captureDevice unlockForConfiguration];
	}
	
}

#pragma mark - Observe
- (void) observeValueForKeyPath: (NSString *)keyPath
					   ofObject: (id)object
						 change: (NSDictionary *)change
						context: (void *)context
{
    if (context == AVCamFocusModeObserverContext) {
        // Update the focus UI overlay string when the focus mode changes
		if (AVCaptureFocusModeAutoFocus==(AVCaptureFocusMode)[[change objectForKey:NSKeyValueChangeNewKey] integerValue]) {
			self.focusView.hidden = NO;
			self.focusView.center = CGPointMake(_captureDevice.focusPointOfInterest.x * _previewView.bounds.size.width,
												_captureDevice.focusPointOfInterest.y * _previewView.bounds.size.height);
			GLOG(@"x:%f,y:%f",_focusView.center.x, _focusView.center.y);
		}else {
			self.focusView.hidden = YES;
		}
	} else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Gesture Recognizer
- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    if ([_captureDevice isFocusPointOfInterestSupported]) {
        CGPoint tapPoint = [gestureRecognizer locationInView:self.previewView];
        CGPoint convertedFocusPoint = [self convertToPointOfInterestFromViewCoordinates:tapPoint];
        [self autoFocusAtPoint:convertedFocusPoint];
    }
}

// Change to continuous auto focus. The camera will constantly focus at the point choosen.
- (void)tapToContinouslyAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    if ([_captureDevice isFocusPointOfInterestSupported])
        [self continuousFocusAtPoint:CGPointMake(.5f, .5f)];
}

// Auto focus at a particular point. The focus mode will change to locked once the auto focus happens.
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates
{
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = _previewView.frame.size;
	
	// Scale, switch x and y, and reverse x
	//	pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
	pointOfInterest = CGPointMake(viewCoordinates.x / frameSize.width, viewCoordinates.y / frameSize.height);
	
	return pointOfInterest;
}

@end
