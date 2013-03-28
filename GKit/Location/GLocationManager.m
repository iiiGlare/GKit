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

#import "GLocationManager.h"
#import "GCore.h"

@implementation GLocationManager

#pragma mark - Init

+ (id)sharedManager
{
	static GLocationManager *_sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedManager = [[GLocationManager alloc] init];
	});
	return _sharedManager;
}

- (id)init
{
	self = [super init];
	if (self) {
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self;
		self.activityType = GActivityTypeOther;
	}
	return self;
}

#pragma mark - Setter / Getter
//desiredAccuracy
- (void)setDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy
{
	self.locationManager.desiredAccuracy = desiredAccuracy;
}
- (CLLocationAccuracy)desiredAccuracy
{
	return self.locationManager.desiredAccuracy;
}
//distanceFilter
- (void)setDistanceFilter:(CLLocationDistance)distanceFilter
{
	self.locationManager.distanceFilter = distanceFilter;
}
- (CLLocationDistance)distanceFilter
{
	return self.locationManager.distanceFilter;
}
//activityType
- (void)setActivityType:(GActivityType)activityType
{
	_activityType = activityType;
	if ([UIDevice isOSVersionHigherThanVersion:@"6.0" includeEqual:YES])
	{
		self.locationManager.activityType = (CLActivityType)_activityType;
	}
}
//gpsIntensity
- (NSInteger)gpsIntensity
{
	CLLocationAccuracy accuracy = [[self.locationManager location] horizontalAccuracy];
	if (accuracy <= kCLLocationAccuracyBest) {
		return MAX_GPS_INTENSITY;
	}else if (accuracy <= kCLLocationAccuracyNearestTenMeters) {
		return MAX_GPS_INTENSITY - 1;
	}else if (accuracy <= kCLLocationAccuracyHundredMeters) {
		return MAX_GPS_INTENSITY - 2;
	}else if (accuracy <= kCLLocationAccuracyKilometer) {
		return MAX_GPS_INTENSITY - 3;
	}else {
		return MAX_GPS_INTENSITY - 4;
	}
}
#pragma mark - Actions
- (void)startUpdatingLocation
{
	[self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
	[self.locationManager stopUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate
//iOS 6
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	if (_blockDidUpdateLocations) {
		_blockDidUpdateLocations(manager, locations);
	}
}
//iOS 2 - 5
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	[self locationManager:manager didUpdateLocations:@[newLocation]];
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error;
{
	GPRINTError(error);
	if (_blockDidFail) {
		_blockDidFail(manager, error);
	}
}

@end
