//
//  AppDelegate.m
//  Wizzem
//
//  Created by Remi Robert on 23/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Crashlytics/Crashlytics.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "AppDelegate.h"
#import "Colors.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UINavigationBar appearance] setTintColor:[UIColor greenColor]];
    
    PFUser *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    if (!user) {
        NSLog(@"not user");
    }
    else {
        NSLog(@"user connected : %@", user.email);
    }
    
    [Parse setApplicationId:@"P2PJVDbhrj37sCtIhVdKvrzrQwq5jFYEIAYsoDfb" clientKey:@"G9h48iFlrF6z2IKAGaXGFolTekaVg04rQpqb7AQZ"];
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
    [Crashlytics startWithAPIKey:@"d9291a9165795274a4a0ad9f612bfafae0b9685d"];
    return YES;
}

@end
