//
//  AppDelegate.m
//  Bearer
//
//  Created by Basel Qumsiyeh on 5/24/14.
//  Copyright (c) 2014 Bearer. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Parse setApplicationId:@"YBCBJjWoVxlTNYuuIVQkFbzNe1qNg9t063HNYSvj"
                  clientKey:@"KoC5zHoFR64c94Ko9YnzdaGHDnjusKn7tkRwmgBz"];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{   
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation[@"deviceName"] = [[UIDevice currentDevice] name];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end
