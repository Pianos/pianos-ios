/*
 * Copyright 2015 Urban Airship and Contributors
 */
#import "GimbalAdapter.h"
#import "UAPush.h"
#import "UAirship.h"
#import "UARegionEvent.h"
#import "UAAnalytics.h"

#define kSource @"Gimbal"

@interface GimbalAdapter ()

@property (assign) BOOL started;
@property (nonatomic) GMBLPlaceManager *placeManager;

@end

@implementation GimbalAdapter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.placeManager = [[GMBLPlaceManager alloc] init];
        self.placeManager.delegate = self;

        // Hide the power alert by default
        if (![[NSUserDefaults standardUserDefaults] valueForKey:@"gmbl_hide_bt_power_alert_view"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"gmbl_hide_bt_power_alert_view"];
        }
    }

    return self;
}

- (void)dealloc {
    self.placeManager.delegate = nil;
}

+ (instancetype)shared {
    static dispatch_once_t onceToken = 0;

    __strong static id _sharedObject = nil;

    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });

    return _sharedObject;
}

- (BOOL)isBluetoothPoweredOffAlertEnabled {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:@"gmbl_hide_bt_power_alert_view"];
}

- (void)setBluetoothPoweredOffAlertEnabled:(BOOL)bluetoothPoweredOffAlertEnabled {
    [[NSUserDefaults standardUserDefaults] setBool:!bluetoothPoweredOffAlertEnabled
                                            forKey:@"gmbl_hide_bt_power_alert_view"];
}

- (void)startAdapter {

    if (self.started) {
        return;
    }

    [GMBLPlaceManager startMonitoring];

    self.started = YES;

    UA_LDEBUG(@"Started Gimbal Adapter.");
}

- (void)stopAdapter {

    if (self.started) {

        [GMBLPlaceManager stopMonitoring];
        self.started = NO;

        UA_LDEBUG(@"Stopped Gimbal Adapter.");
    }
}

- (void)reportPlaceEventToAnalytics:(GMBLPlace *) place boundaryEvent:(UABoundaryEvent) boundaryEvent {
    UARegionEvent *regionEvent = [UARegionEvent regionEventWithRegionID:place.identifier source:kSource boundaryEvent:boundaryEvent];

    [[UAirship shared].analytics addEvent:regionEvent];
}

#pragma mark -
#pragma mark Gimbal places callbacks

- (void)placeManager:(GMBLPlaceManager *)manager didBeginVisit:(GMBLVisit *)visit {
    UA_LDEBUG(@"Entered a Gimbal Place: %@ on the following date: %@", visit.place.name, visit.arrivalDate);

    [self reportPlaceEventToAnalytics:visit.place boundaryEvent:UABoundaryEventEnter];
}

- (void)placeManager:(GMBLPlaceManager *)manager didEndVisit:(GMBLVisit *)visit {
    UA_LDEBUG(@"Exited a Gimbal Place: %@ Entrance date:%@ Exit Date:%@", visit.place.name, visit.arrivalDate, visit.departureDate);

    [self reportPlaceEventToAnalytics:visit.place boundaryEvent:UABoundaryEventExit];
}


@end
