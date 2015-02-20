//
//  AppDelegate.m
//  PianoPushPlay
//
//  Created by James Stiehl on 1/20/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import "AppDelegate.h"
#import <AirshipKit/AirshipKit.h>
@import AirshipKit;
#import <FYX/FYX.h>
#import <FYX/FYXLogging.h>
#import <FYX/FYXVisitManager.h>
#import <FYX/FYXVisitManager.h>
#import <FYX/FYXTransmitter.h>



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.request = [[HttpModule alloc] init];
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    FindPianosViewController *findPianos = [storyboard instantiateViewControllerWithIdentifier:@"findPianos"];
//    [self.window makeKeyAndVisible];
//    [self.window.rootViewController presentViewController:findPianos animated:NO completion:^{
//    NSLog(@"Find Pianos Screen Loaded");
//    }];
    
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
    [[UAPush shared] resetBadge];
    
    
    
    // Set the notification types required for the app (optional). This value defaults
    // to badge, alert and sound, so it's only necessary to set it if you want
    // to add or remove types.
    [UAPush shared].userNotificationTypes = (UIUserNotificationTypeAlert |
                                             UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound);
    
    
    // User notifications will not be enabled until userPushNotificationsEnabled is
    // set YES on UAPush. Once enabled, the setting will be persisted and the user
    // will be prompted to allow notifications. You should wait for a more appropriate
    // time to enable push to increase the likelihood that the user will accept
    // notifications.
    [UAPush shared].userPushNotificationsEnabled = YES;
    
   // [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:@"fyx_post_to_server_interval_preference"];
    
    //***********End UA********************************************
    
    //Gimbal stuff/////
    
    
    [FYX setAppId:@"ba2d3d98fabff232a889304c5cfa3d2643de5c517a188b6af3b5f33b1d4272e7" appSecret:@"5f01b3e6808bcdb869a1eb66b9d17f2ef56ea60ce1bc271d002afefb1f80d516" callbackUrl:@"combirddogmapsexample://authcode"];
    
    [FYXLogging setLogLevel:FYX_LOG_LEVEL_INFO];
    
    
    
    [FYX startService:self];
    
    //Gimbal stuff/////
    
    return YES;
}

/*- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    // URL is myapp://discount-scheme/id304
    if ([url.scheme isEqualToString:@"piano.push"]) {
        if ([url.relativePath isEqualToString:@"/piano1"]) {
            // Handle deep link in app. Do something inside your app.

        }
    }
    
    return YES;
}
 */


/*- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSMutableArray *schemes = [NSMutableArray array];
    
    // Look at our plist
    NSArray *bundleURLTypes = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    [bundleURLTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [schemes addObjectsFromArray:[bundleURLTypes[idx] objectForKey:@"CFBundleURLSchemes"]];
    }];
    
    if (![schemes containsObject:[url scheme]]) {
        return NO;
    }
    
    [self deepLink:[url pathComponents]];
    
    return YES;
 }
*/

- (void)serviceStarted
{
    // this will be invoked if the service has successfully started
    // bluetooth scanning will be started at this point.
    NSLog(@"FYX Service Successfully Started");
    
    self.visitManager = [FYXVisitManager new];
    self.visitManager.delegate = self;
    [self.visitManager start];
    
}

- (void)startServiceFailed:(NSError *)error
{
    // this will be called if the service has failed to start
    NSLog(@"%@", error);
}

- (void)didArrive:(FYXVisit *)visit;
{
    // this will be invoked when an authorized transmitter is sighted for the first time
    NSLog(@"I arrived at a Gimbal Beacon!!! %@", visit.transmitter.name);
    
    
    //NEED TO ADD MY TAGS:
    //  if (visit.transmitter.) {
    
    
    // Add the beacon-nearby-<NAME> tag
    [[UAPush shared] addTag:[NSString stringWithFormat:@"beacon-nearby-%@", visit.transmitter.name]];
    
    // Add the beacon-visited-<NAME> tag
    [[UAPush shared] addTag:[NSString stringWithFormat:@"beacon-visited-%@", visit.transmitter.name]];
    
    // Update registration
    [[UAPush shared] updateRegistration];
    
    //   }
}


- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI;
{
    // this will be invoked when an authorized transmitter is sighted during an on-going visit
    NSLog(@"I received a sighting!!! %@", visit.transmitter.name);
}


- (void)didDepart:(FYXVisit *)visit;
{
    // this will be invoked when an authorized transmitter has not been sighted for some time
    NSLog(@"I left the proximity of a Gimbal Beacon!!!! %@", visit.transmitter.name);
    NSLog(@"I was around the beacon for %f seconds", visit.dwellTime);
    
    //DO WE WANT TO REMOVE TAGS WHEN THEY LEAVE? WHICH ONES?
    // Remove the beacon-nearby-<NAME> tag
    [[UAPush shared] removeTag:[NSString stringWithFormat:@"beacon-nearby-%@", visit.transmitter.name]];
    
    [[UAPush shared] removeTag:[NSString stringWithFormat:@"beacon-visited-%@", visit.transmitter.name]];
    
    // Update registration
    [[UAPush shared] updateRegistration];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
