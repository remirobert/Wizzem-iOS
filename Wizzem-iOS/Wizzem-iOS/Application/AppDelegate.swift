//
//  AppDelegate.swift
//  Wizzem
//
//  Created by Remi Robert on 09/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
        
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.setApplicationId("P2PJVDbhrj37sCtIhVdKvrzrQwq5jFYEIAYsoDfb", clientKey: "G9h48iFlrF6z2IKAGaXGFolTekaVg04rQpqb7AQZ")
        PFFacebookUtils.initializeFacebook()
        
        let typeSettingsNotification: UIUserNotificationType = ([UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound])
        let notificationSettings = UIUserNotificationSettings(forTypes: typeSettingsNotification, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = UIColor.whiteColor()
 
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().backgroundColor = UIColor.whiteColor()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        if (PFUser.currentUser() != nil) {
            window?.rootViewController = InstanceController.fromStoryboard("mainController")
        }
        else {
            window?.rootViewController = InstanceController.fromStoryboard(CONTROLLER_LOGIN)
        }
        
        window?.makeKeyAndVisible()
        PBJVision.sharedInstance().startPreview()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        print("application recaived link: \(url.absoluteString)")

        if let eventId = url.absoluteString.componentsSeparatedByString("eventId=").last {
            if (PFUser.currentUser() != nil) {
                window?.rootViewController = InstanceController.fromStoryboard("mainController")
                (window?.rootViewController as! MainTabBarViewController).displayInvitation(eventId)
            }
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        if let eventId = url.absoluteString.componentsSeparatedByString("eventId=").last {
            if (PFUser.currentUser() != nil) {
                window?.rootViewController = InstanceController.fromStoryboard("mainController")
                (window?.rootViewController as! MainTabBarViewController).displayInvitation(eventId)
            }
        }
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        FBSDKAppEvents.activateApp()
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.channels = ["global"]
        currentInstallation.saveInBackgroundWithBlock { (_, err: NSError?) -> Void in
            print("err set device token : \(err)")
        }
    }
}

