//
//  WizzemAPI.swift
//  
//
//  Created by Remi Robert on 20/06/15.
//
//

import UIKit

class WizzemAPI: NSObject {
   
    class func getMyEvents(completionBlock block: (result: Result, events: [AnyObject]?)->()) {
        if let currentUser = PFUser.currentUser() {
            let querry = PFQuery(className: "Participant")
            querry.whereKey("userId", equalTo: PFUser.currentUser()!)
            querry.findObjectsInBackgroundWithBlock({ (results: [AnyObject]?, error: NSError?) -> Void in
                if error != nil {
                    block(result: Result.👎(statusCode: nil, error: error), events: nil)
                    return
                }
                block(result: Result.👍, events: results)
                print(results, terminator: "")
            })
        }
        else {
            block(result: Result.👎(statusCode: nil, error: nil), events: nil)
        }
    }
}
