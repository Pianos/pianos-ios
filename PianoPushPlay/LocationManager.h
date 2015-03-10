//
//  LocationManager.h
//  PianoPushPlay
//
//  Created by James Stiehl on 3/5/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property CLLocation *startingLocation;

@end
