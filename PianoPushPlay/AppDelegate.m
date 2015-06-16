//
//  AppDelegate.m
//  PianoPushPlay
//
//  Created by James Stiehl on 1/20/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import "AppDelegate.h"
#import "UAirship.h"
#import "UAConfig.h"
#import "UAPush.h"
#import "DetailsViewController.h"
#import "GimbalAdapter.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.locationManager = [[LocationManager alloc] init];
    self.request = [[HttpModule alloc] init];
    
    //****************Adding Necessary UA Stuff *******************
    [UAirship setLogLevel:UALogLevelTrace];
    
    // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
    // or set runtime properties here.
    UAConfig *config = [UAConfig defaultConfig];
    
    // You can then programmatically override the plist values:
    // config.developmentAppKey = @"YourKey";
    // etc.
    
    // Call takeOff (which creates the UAirship singleton)
    [UAirship takeOff:config];
    
    // Print out the application configuration for debugging (optional)
    UA_LDEBUG(@"Config:\n%@", [config description]);
    
    // Set the icon badge to zero on startup (optional)
    [[UAirship push] resetBadge];
    
    // Set the notification types required for the app (optional). This value defaults
    // to badge, alert and sound, so it's only necessary to set it if you want
    // to add or remove types.
    [UAirship push].userNotificationTypes = (UIUserNotificationTypeAlert |
                                             UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound);
    
    
    // User notifications will not be enabled until userPushNotificationsEnabled is
    // set YES on UAPush. Once enabled, the setting will be persisted and the user
    // will be prompted to allow notifications. You should wait for a more appropriate
    // time to enable push to increase the likelihood that the user will accept
    // notifications.
    [UAirship push].userPushNotificationsEnabled = YES;
    
    //***********End UA********************************************
    
    //Gimbal stuff:
    
    //Need to add the APPLICATION KEY HERE. Not the rest API key:
    [Gimbal setAPIKey:@"9d60ff6d-7a1f-4161-8ef6-7625905d3d82" options:nil];
    
    //Start the UA/Gimbal Adapter
    [[GimbalAdapter shared] startAdapter];

    //Initialize and start the place manager
    self.placeManager = [GMBLPlaceManager new];
    self.placeManager.delegate = self;
    [GMBLPlaceManager startMonitoring];
    

    //Initialize and start the communications manager
    self.communicationManager = [GMBLCommunicationManager new];
    self.communicationManager.delegate = self;
    [GMBLCommunicationManager startReceivingCommunications];


    
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSMutableArray *schemes = [NSMutableArray array];
    // Look at our plist
    NSArray *bundleURLTypes = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    [bundleURLTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [schemes addObjectsFromArray:[bundleURLTypes[idx] objectForKey:@"CFBundleURLSchemes"]];
    }];
    if (![schemes containsObject:[url scheme]]) {

        return NO;
    }
    NSLog(@"Schemes: %@", schemes);
    NSLog(@"Url:%@", url);
    NSLog(@"Url Path components:%@", [url pathComponents]);
    NSLog(@"Url Last Path components:%@", [url lastPathComponent]);
    NSLog(@"Url host:%@", [url host]);
    [self deepLink:[url host] piano:[url lastPathComponent]];
    return YES;
}
- (void)deepLink:(NSString *)path piano:(NSString *)lastPath {
    NSLog(@"I am getting into path");
    // Store valid storyboard IDs in an array to avoid exceptions at
    // runtime
    // NSArray *linkableStoryboardIDs = @[@"checkIn"];
    NSLog(@"path: %@", path);
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    NSLog(@"nav = %@", navController);
    //[navController popToRootViewControllerAnimated:NO];
    // UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NSMutableArray *viewControllers = [navController.viewControllers mutableCopy];
    // if ([path isEqualToString: @"checkIn"]) {
    // [viewControllers addObject:[storyboard instantiateViewControllerWithIdentifier:path]];
    DetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"checkIn"];
    vc.pianoName = lastPath;
    [navController pushViewController:vc animated:YES];
    // }
    NSLog(@"vc = %@", viewControllers);
    //navController.viewControllers = viewControllers;
}

# pragma mark - Gimbal PlaceManager delegate methods

- (void)placeManager:(GMBLPlaceManager *)manager didBeginVisit:(GMBLVisit *)visit
{
    NSLog(@"I arrived at a Gimbal Beacon!!!");
}

- (void)placeManager:(GMBLPlaceManager *)manager didEndVisit:(GMBLVisit *)visit
{
     NSLog(@"I left a Gimbal Beacon!!!");
}

# pragma mark - Gimbal CommunicationManager delegate methods

- (NSArray *)communicationManager:(GMBLCommunicationManager *)manager
presentLocalNotificationsForCommunications:(NSArray *)communications
                         forVisit:(GMBLVisit *)visit
{
    return communications;
}



@end
