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
        }
    }

    class func pushNotification(group: String, message: String) {
        PFPush.sendPushMessageToChannelInBackground(group, withMessage: message) { (_, err: NSError?) -> Void in
        }
    }
}
