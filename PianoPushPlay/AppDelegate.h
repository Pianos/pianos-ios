//
//  AppDelegate.h
//  PianoPushPlay
//
//  Created by James Stiehl on 1/20/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpModule.h"
#import "FindPianosViewController.h"
//#import <FYX/FYX.h>
//#import <FYX/FYXVisitManager.h>
#import "LocationManager.h"
#import <Gimbal/Gimbal.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, GMBLPlaceManagerDelegate,  GMBLCommunicationManagerDelegate>
@property (nonatomic) GMBLCommunicationManager *communicationManager;
@property (nonatomic) GMBLBeaconManager *beaconManager;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) GMBLPlaceManager *placeManager;
@property (strong, nonatomic) HttpModule *request;
//@property (nonatomic) FYXVisitManager *visitManager;
@property (nonatomic, retain) LocationManager *locationManager;


@end

