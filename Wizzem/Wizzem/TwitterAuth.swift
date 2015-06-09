//
//  TwitterAuth.swift
//  Wizzem
//
//  Created by Remi Robert on 09/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class TwitterAuth: NSObject {
   
    class func login(completionBlock: (result: Result)->()) {
        PFTwitterUtils.logInWithBlock { (user: PFUser?, error: NSError?) -> Void in
            if (user == nil) {
                completionBlock(result: Result.👎(statusCode: nil, error: error))
            }
            else {
                if user!.isNew {
                }
                completionBlock(result: Result.👍)
            }
        }
    }
    
}
