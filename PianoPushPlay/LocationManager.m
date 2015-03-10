//
//  LocationManager.m
//  PianoPushPlay
//
//  Created by James Stiehl on 3/5/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

-(id)init{
    self = [super init];
    
    if(self) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager setDelegate:self];
        [self.locationManager setDistanceFilter:10];
        [self.locationManager requestWhenInUseAuthorization];
        
    }
    
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse){
        [self.locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currentLocation = [locations lastObject];
    
    if(self.startingLocation == nil){
        
        self.startingLocation = self.currentLocation;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updatedLocation" object:self.currentLocation];
        
    }
}

@end
