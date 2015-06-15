/*
 * Copyright 2015 Urban Airship and Contributors
 */

#import <Foundation/Foundation.h>
#import <Gimbal/Gimbal.h>

/**
 * GimbalAdapter interfaces Gimbal SDK functionality with Urban Airship services.
 */
@interface GimbalAdapter : NSObject <GMBLPlaceManagerDelegate>

/**
 * Enables alert when Bluetooth is powered off. Defaults to NO.
 */
@property (nonatomic, assign, getter=isBluetoothPoweredOffAlertEnabled) BOOL bluetoothPoweredOffAlertEnabled;

/**
 * Returns the shared `GimbalAdapter` instance.
 *
 * @return The shared `GimbalAdapter` instance.
 */
+ (instancetype)shared;

/**
 * Starts Gimbal.
 */
- (void)startAdapter;

/**
 * Stops Gimbal.
 */
- (void)stopAdapter;

@end
