//
//  EventCloud.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 06/09/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class EventCloud: NSObject {
   
    class func checkParticipantToEvent(event: PFObject, blockParticipant: ((isParticipant: Bool) -> Void)) {
        let querry = PFQuery(className: "Participant")
        querry.whereKey("eventId", equalTo: event)
        querry.whereKey("userId", equalTo: PFUser.currentUser()!)
        
        querry.getFirstObjectInBackgroundWithBlock { (result: PFObject?, err: NSError?) -> Void in
            if err != nil || result == nil {
                blockParticipant(isParticipant: false)
            }
            else {
                blockParticipant(isParticipant: true)
            }
        }
    }
}
