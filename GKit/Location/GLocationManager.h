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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GLocationManager : NSObject
<CLLocationManagerDelegate>

+ (id)sharedManager;

//LocationManager
@property (nonatomic, strong) CLLocationManager *locationManager;

enum {
    GActivityTypeOther = 1,				// default
    GActivityTypeAutomotiveNavigation,	// for automotive navigation
    GActivityTypeFitness,				// includes any pedestrian activities
    GActivityTypeOtherNavigation 		// for other navigation cases (excluding pedestrian navigation), e.g. navigation for boats, trains, or planes
};
typedef NSInteger GActivityType;

@property (nonatomic, assign) CLLocationAccuracy desiredAccuracy;
@property (nonatomic, assign) CLLocationDistance distanceFilter;
@property (nonatomic, assign) GActivityType activityType;

//1 - 5
#define MAX_GPS_INTENSITY 5
@property (nonatomic, readonly) NSInteger gpsIntensity;

//CallBack
@property (nonatomic, copy) void (^blockDidUpdateLocations)(CLLocationManager *locationManager, NSArray *locations);
@property (nonatomic, copy) void (^blockDidFail)(CLLocationManager *locationManager, NSError *error);

//Actions
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
