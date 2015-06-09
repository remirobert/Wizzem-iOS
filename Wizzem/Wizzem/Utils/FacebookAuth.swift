//
//  FacebookAuth.swift
//  Wizzem
//
//  Created by Remi Robert on 09/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class FacebookAuth {
   
    static let permissionsArray = ["user_about_me", "user_friends"]
    
    class func login(completionBlock: (result: Result)->()) {
        PFFacebookUtils.logInWithPermissions(permissionsArray, block: { (user: PFUser?, error: NSError?) -> Void in
            if (user == nil) {
                completionBlock(result: Result.👎(statusCode: nil, error: error))
            }
            else {
                if user!.isNew {
                }
                completionBlock(result: Result.👍)
            }
        })
    }
    
}
