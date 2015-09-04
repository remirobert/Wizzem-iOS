//
//  FacebookAuth.swift
//  Wizzem
//
//  Created by Remi Robert on 09/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class FacebookAuth {
    static let permissionsArray = ["user_about_me", "user_friends", "email", "user_events"]
    
    private class func createNewUser(user: PFUser, blockCompletion: (success: Bool, error: NSError?) -> Void) {
        FBRequestConnection.startForMeWithCompletionHandler { (_, result: AnyObject!, error: NSError!) -> Void in
            if let result = result as? NSDictionary {
                
                println("result \(result)")
                
                let facebookID = result.objectForKey("id") as? String
                let firstName = result.objectForKey("first_name") as? String
                let lastName = result.objectForKey("last_name") as? String
                let email = result.objectForKey("email") as? String
                let birthday = result.objectForKey("birthday") as? String
                let gender = result.objectForKey("gender") as? String
                
                var fileProfileImage: PFFile?
                if let facebookID = facebookID,
                    let pictureUrl = NSURL(string: "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"),
                    let dataImage = NSData(contentsOfURL: pictureUrl) {
                        fileProfileImage = PFFile(name: "profilePicture.png", data: dataImage)
                }
                
                user.setValue(facebookID, forKey: "facebookId")
                user.setValue(email, forKey: "email")
                user.setValue(firstName, forKey: "first_name")
                user.setValue(lastName, forKey: "last_name")
                user.setValue("\(firstName!)\(lastName!)", forKey: "true_username")
                user.setValue(email, forKey: "username")
                user.setValue(birthday, forKey: "birthdate")
                user.setValue(gender, forKey: "gender")
                if let fileProfileImage = fileProfileImage {
                    user.setValue(fileProfileImage, forKey: "picture")
                }
                
                user.saveInBackgroundWithBlock({ (success: Bool, err: NSError?) -> Void in
                    if success {
                        blockCompletion(success: true, error: nil)
                    }
                    else {
                        blockCompletion(success: false, error: err)
                    }
                })
            }
            else {
                
                println("error : \(error)")
                
                blockCompletion(success: false, error: error)
            }
        }
    }
    
    class func login(completionBlock: (result: Result)->()) {
        FBSession.activeSession()
        PFFacebookUtils.logInWithPermissions(permissionsArray, block: { (user: PFUser?, error: NSError?) -> Void in
            println("error : \(error)")
            if (user == nil) {
                completionBlock(result: Result.👎(statusCode: nil, error: error))
            }
            else {
                if user!.isNew {
                    println("FACEBOOK new user creation")
                    self.createNewUser(user!, blockCompletion: { (success, error) -> Void in
                        if success {
                            completionBlock(result: Result.👍)
                        }
                        else {
                            completionBlock(result: Result.👎(statusCode: nil, error: error))
                        }
                    })
                }
                else {
                    println("FACEBOOK user login ok !")
                    completionBlock(result: Result.👍)
                }
            }
        })
    }
}
