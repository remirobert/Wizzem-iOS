//
//  AppDelegate.swift
//  Wizzem
//
//  Created by Remi Robert on 09/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseUI
import ParseFacebookUtils
import PBJVision

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.setApplicationId("P2PJVDbhrj37sCtIhVdKvrzrQwq5jFYEIAYsoDfb", clientKey: "G9h48iFlrF6z2IKAGaXGFolTekaVg04rQpqb7AQZ")
        PFFacebookUtils.initializeFacebook()
        
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
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

}

