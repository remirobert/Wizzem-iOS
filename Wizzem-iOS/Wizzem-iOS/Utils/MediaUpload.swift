//
//  Media.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 01/09/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class MediaUpload: NSObject {
    
    class func addMedia(event: PFObject, media: NSData, completion: ((sucess: Bool)->Void)) {
        let file = PFFile(data: media)
        
        file.saveInBackgroundWithBlock { (_, err: NSError?) -> Void in
            
            let username = (PFUser.currentUser()!["true_username"] as? String)!
            let nameEvent = (event["title"] as? String)!
            let message = "\(username) à publier dans \(nameEvent)."
            
            println("message : \(message)")
            
            if err != nil {
                Alert.error("Vous devez selectionnez ou créer un moment avant de publier.")
                return
            }
            
            let params = NSMutableDictionary()
            params.setValue(event.objectId!, forKey: "eventId")
            params.setValue(PFUser.currentUser()!.objectId!, forKey: "userId")
            params.setValue(event.objectId!, forKey: "eventId")
            params.setValue(file, forKey: "file")
            params.setValue("photo", forKey: "type")
            
            PFCloud.callFunctionInBackground("MediaAdd", withParameters: params as [NSObject : AnyObject]) { (_, error: NSError?) -> Void in
                if let error = error {
                    println("error : \(error)")
                    ProgressionData.completeDataProgression()
                    Alert.error("Erreur lors de l'uplaod de votre Wizz.")
                    completion(sucess: false)
                }
                else {
                    self.checkJoinUser(event.objectId!, event: event)
                    completion(sucess: true)
                    ProgressionData.completeDataProgression()
                    NSNotificationCenter.defaultCenter().postNotificationName("reloadContent", object: nil)
                }
            }
        }
    }
    
    class func checkJoinUser(eventId: String, event: PFObject) {
        let querry = PFQuery(className: "Participant")
        querry.whereKey("eventId", equalTo: event)
        querry.whereKey("userId", equalTo: PFUser.currentUser()!)
        
        querry.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, _) -> Void in
            if results == nil || results?.count == 0 {
                let newParticipant = PFObject(className: "Participant")
                newParticipant["eventId"] = event
                newParticipant["userId"] = PFUser.currentUser()!
                newParticipant["approval"] = true
                newParticipant["invited"] = false
                newParticipant["status"] = "accepted"
                newParticipant.saveInBackgroundWithBlock({ (success: Bool, _) -> Void in
                    if success {
                        println("sucess add")
                        
                        let name = PFUser.currentUser()!["true_username"] as? String
                        let nameEvent = event["title"] as? String
                        PushNotification.addNotificationAndPush("c\(event.objectId!)", message: "\(name) à publier dans \(nameEvent)")
                        
                        if let numberParticipant = event["nbParticipant"] as? Int {
                            event["nbParticipant"] = numberParticipant + 1
                            event.saveInBackgroundWithBlock({ (_, _) -> Void in})
                        }
                    }
                    else {
                        Alert.error("Erreur lors de l'uplaod de votre Wizz.")
                    }
                })
            }
        }
    }
    
}
