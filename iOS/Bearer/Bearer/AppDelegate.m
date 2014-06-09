//
//  AppDelegate.m
//  Bearer
//
//  Created by Basel Qumsiyeh on 5/24/14.
//  Copyright (c) 2014 Bearer. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "ReceivedContentTableViewController.h"

@implementation AppDelegate

@synthesize potentialSCId;
@synthesize viewDeck;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Parse setApplicationId:@"YBCBJjWoVxlTNYuuIVQkFbzNe1qNg9t063HNYSvj"
                  clientKey:@"KoC5zHoFR64c94Ko9YnzdaGHDnjusKn7tkRwmgBz"];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    NSString *sentContentId = [notificationPayload valueForKey:@"sentContentId"];
    if (sentContentId && [PFUser currentUser]) {
        [self handlePushNotification:sentContentId];
    }
    
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
    NSString *sentContentId = [userInfo valueForKey:@"sentContentId"];
    
    if (application.applicationState == UIApplicationStateActive) {
        self.potentialSCId = sentContentId;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Content Received"
                                                        message:[userInfo valueForKey:@"text"]
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:@"Open", nil];
        [alert show];
    }
    else {
        [self handlePushNotification:sentContentId];
    }
}

- (void)handlePushNotification:(NSString *)sentContentId {
    
    if (![PFUser currentUser]) {
        UIViewController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"login"];
        [[self getMainNavController] setViewControllers:[NSArray arrayWithObject:loginVC] animated:YES];
    }
    else {
        ReceivedContentTableViewController *sentContentVC = (ReceivedContentTableViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"receivedContentTable"];
        
        //auto open the sent content, once we finish loading data
        sentContentVC.autoOpenRecordId = sentContentId;
        
        [[self getMainNavController] setViewControllers:[NSArray arrayWithObject:sentContentVC] animated:NO];
    }
}
#pragma mark - Helpers
- (UINavigationController *)getMainNavController {
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    if ([nav isKindOfClass:[UINavigationController class]])
        return nav;
    return nil;
}

#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [self handlePushNotification:self.potentialSCId];
    }
    
    self.potentialSCId = nil;
}

+ (UIImage *)symbolSetImgFromText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color {
    
    // set the font type and size
    UIFont *font = [UIFont fontWithName:@"SSStandard" size:fontSize];
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    
    // check if UIGraphicsBeginImageContextWithOptions is available (iOS is 4.0+)
    if (UIGraphicsBeginImageContextWithOptions != NULL)
        UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    else
        // iOS is < 4.0
        UIGraphicsBeginImageContext(size);
    
    [text drawAtPoint:CGPointMake(0.0, 0.0) withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color}];
    
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
