//
//  PushNotification.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 01/09/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class PushNotification: NSObject {
   
    class func addNotification(group: String) {
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.addUniqueObject(group, forKey: "channels")
        currentInstallation.saveInBackgroundWithBlock { (_, err: NSError?) -> Void in
            println("error add channels : \(err)")
        }
    }
    
    class func addNotifications(group: [String]) {
        let currentInstallation = PFInstallation.currentInstallation()
        for currentNotif in group {
            currentInstallation.addUniqueObject(currentNotif, forKey: "channels")
        }
        currentInstallation.saveInBackgroundWithBlock { (_, err: NSError?) -> Void in
            println("error add channels : \(err)")
        }
    }

    class func pushNotification(group: String, message: String) {
        PFPush.sendPushMessageToChannelInBackground(group, withMessage: message) { (_, err: NSError?) -> Void in
            println("error push notification : \(err)")
        }
    }
    
    class func addNotificationAndPush(group: String, message: String) {
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.addUniqueObject(group, forKey: "channels")
        currentInstallation.saveInBackgroundWithBlock { (_, err: NSError?) -> Void in
            self.pushNotification(group, message: message)
        }
    }
}
