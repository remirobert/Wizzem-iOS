//
//  AddMedia.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 15/09/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class MediaFile: NSObject {
 
    class func add(media: PFFile, type: String,  event: PFObject, blockCompletion: ((success: Bool)->())) {
        media.saveInBackgroundWithBlock { (_, err: NSError?) -> Void in
            if err != nil {
                Alert.error("Vous devez selectionnez ou créer un moment avant de publier.")
                blockCompletion(success: false)
                return
            }
            
            let params = NSMutableDictionary()
            
            params.setValue(event.objectId!, forKey: "eventId")
            params.setValue(PFUser.currentUser()!.objectId!, forKey: "userId")
            params.setValue(media, forKey: "file")
            params.setValue(type, forKey: "type")

            PFCloud.callFunctionInBackground("MediaAdd", withParameters: params as [NSObject : AnyObject])
                { (media: AnyObject?, error: NSError?) -> Void in
                    
                    if let error = error {
                        Alert.error("Erreur lors de l'uplaod de votre Wizz.")
                        blockCompletion(success: false)
                    }
                    else {
                        let username = (PFUser.currentUser()!["true_username"] as? String)!
                        let nameEvent = (event["title"] as? String)!
                        let message = "\(username) à publier un nouveau média dans \(nameEvent)."
                        
                        if let media = media as? PFObject {
                            media["creationDate"] = NSDate()
                            media.saveInBackgroundWithBlock({ (_, error: NSError?) -> Void in
                                if error == nil {
                                    blockCompletion(success: true)
                                }
                                else {
                                    Alert.error("Erreur lors de l'uplaod de votre Wizz.")
                                    blockCompletion(success: false)
                                }
                            })
                        }
                    }
            }
        }
    }
}
