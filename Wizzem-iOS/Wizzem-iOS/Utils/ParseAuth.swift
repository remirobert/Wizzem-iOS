//
//  ParseAuth.swift
//  Wizzem
//
//  Created by Remi Robert on 09/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class ParseAuth {
   
    class func login(username username: String, userPassword password: String, completionBlock block: (result: Result)->()) {
        PFUser.logInWithUsernameInBackground(username, password:password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user == nil {
                block(result: Result.👎(statusCode: nil, error: error))
            } else {
                block(result: Result.👍)
            }
        }
    }

    class func signup(user user: PFUser, completionBlock block: (result: Result)->()) {
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                block(result: Result.👎(statusCode: nil, error: error))
            } else {
                block(result: Result.👍)
            }
        }
    }

}
