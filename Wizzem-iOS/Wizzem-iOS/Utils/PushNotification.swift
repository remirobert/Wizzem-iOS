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
        PFPush.subscribeToChannelInBackground(group, block: { (_, err: NSError?) -> Void in
            if err != nil {
                print("err subscribe channel : \(err)")
            }
        })
    }
    
    class func addNotifications(group: [String]) {
        let currentInstallation = PFInstallation.currentInstallation()
        for currentNotif in group {
            currentInstallation.addUniqueObject(currentNotif, forKey: "channels")
            
            PFPush.subscribeToChannelInBackground(currentNotif, block: { (_, err: NSError?) -> Void in
                if err != nil {
                    print("err subscribe channel : \(err)")
                }
            })
        }
    }

    class func pushNotification(group: String, message: String) {
        let data = [
            "alert" : message,
            "badge" : 1,
            "sounds" : ""
        ]
        let push = PFPush()
        push.setChannels([group])
        push.setData(data as [NSObject : AnyObject])

        push.sendPushInBackgroundWithBlock { (_, err: NSError?) -> Void in
            print("error push notification : \(err)")
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
