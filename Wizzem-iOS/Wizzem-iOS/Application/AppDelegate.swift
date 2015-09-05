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
        
        var typeSettingsNotification = (UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound)
        let notificationSettings = UIUserNotificationSettings(forTypes: typeSettingsNotification, categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
        
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
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        println("application recaived link: \(url.absoluteString)")

        if let eventId = url.absoluteString?.componentsSeparatedByString("eventId=").last {
            //let param = NSMutableDictionary()
            //param.setValue(eventId, forKey: "eventId")
            
            
            //NSNotificationCenter.defaultCenter().postNotificationName("notificationInvitation", object: nil, userInfo: param as [NSObject : AnyObject])
            
            println("root :\(window?.rootViewController)")
            
            
            if (PFUser.currentUser() != nil) {
                window?.rootViewController = InstanceController.fromStoryboard("mainController")
                (window?.rootViewController as! MainTabBarViewController).displayInvitation(eventId)
                
            }
//            if let rootController = window?.rootViewController as? MainTabBarViewController {
//                rootController.displayInvitation(eventId)
//            }
            
            println("receive for event : \(eventId)")
        }

        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.channels = ["global"]
        currentInstallation.save()
    }
}

