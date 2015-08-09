//
//  UIViewController+Invitation.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 08/08/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class UIViewControllerInvitation: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserverForName("notificationInvitation", object: nil, queue: nil) { (notification: NSNotification!) -> Void in
            
            let params: [NSObject : AnyObject] = notification.userInfo!
            let eventId = params["eventId"] as! String
            
            let alertController = UIAlertController(title: "Vous avez reçu une invitation", message: "De l'event : \(eventId)", preferredStyle: UIAlertControllerStyle.Alert)

            let cancel = UIAlertAction(title: "Refuser", style: UIAlertActionStyle.Default, handler: nil)
            let joinAction = UIAlertAction(title: "Rejoindre", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
                
            })
            alertController.addAction(cancel)
            alertController.addAction(joinAction)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}