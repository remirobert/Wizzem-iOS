//
//  Media.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 01/09/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class MediaUpload: NSObject {
    
    var hud: MBProgressHUD!
    var event: PFObject!
    var medias = Array<NSData>()
    var creationDates = Array<NSDate>()
    var currentCount: Int!
    var completion: (() -> ())!
    
    func addMedia() {
        if self.currentCount >= self.medias.count {
            hud.hide(true)
            self.completion()
            return
        }
        
        let file = PFFile(data: self.medias[self.currentCount])
        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.hud.labelText = "Upload [\(self.currentCount + 1) / \(self.medias.count)] (0%)"
//        })
        
        file.saveInBackgroundWithBlock({ (_, err: NSError?) -> Void in
            let username = (PFUser.currentUser()!["true_username"] as? String)!
            let nameEvent = (self.event["title"] as? String)!
            let message = "\(username) à publier dans \(nameEvent)."
            
            print("message : \(message)")
            
            if err != nil {
                Alert.error("Vous devez selectionnez ou créer un moment avant de publier.")
                return
            }
            
            let params = NSMutableDictionary()
            params.setValue(self.event.objectId!, forKey: "eventId")
            params.setValue(PFUser.currentUser()!.objectId!, forKey: "userId")
            params.setValue(self.event.objectId!, forKey: "eventId")
            params.setValue(file, forKey: "file")
            params.setValue("photo", forKey: "type")
            params.setValue(self.creationDates[self.currentCount], forKey: "creationDate")
            
            PFCloud.callFunctionInBackground("MediaAdd", withParameters: params as [NSObject : AnyObject]) { (media :AnyObject?, error: NSError?) -> Void in
                if let error = error {
                    print("error : \(error)")
                    Alert.error("Erreur lors de l'uplaod de votre Wizz.")
                    self.currentCount! += 1
                    self.addMedia()
                }
                else {
                    self.checkJoinUser(self.event.objectId!, event: self.event)
                    
                    if let media = media as? PFObject {
                        media["creationDate"] = self.creationDates[self.currentCount]
                        
                        media.saveInBackgroundWithBlock({ (_, error: NSError?) -> Void in
                            self.currentCount! += 1
                            self.addMedia()
                        })
                    }
                }
            }
            }, progressBlock: { (progress: Int32) -> Void in
                print("progress : \(progress)")
                //dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.hud.labelText = "Upload [\(self.currentCount + 1) / \(self.medias.count)] (\(progress)%)"
                //})
        })
        
//        file.saveInBackgroundWithBlock { (_, err: NSError?) -> Void in
//            
//        }
    }
    
    func checkJoinUser(eventId: String, event: PFObject) {
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
                        print("sucess add")
                        
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
    
    class func uploadMedia(medias: [NSData], creationDates: [NSDate], event: PFObject, view: UIView) {
        let mediaUpload = MediaUpload()

        mediaUpload.hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        mediaUpload.event = event
        mediaUpload.currentCount = 0
        mediaUpload.medias = medias
        
        mediaUpload.addMedia()
    }
    
}
