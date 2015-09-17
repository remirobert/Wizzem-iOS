//
//  FacebookKit.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 16/09/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class FacebookKit: NSObject {
 
    private var eventsList = Array<NSDictionary>()
    private var eventsId = Array<String>()
    private var objectsEventsList = Array<Event>()
    private var blockCompletion: ((events: [Event]?) -> Void)!
    
    class var sharedInstance: FacebookKit! {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: FacebookKit? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = FacebookKit()
        }
        return Static.instance!
    }
    
    private func fetchEvent() {
        if let currentEventDictionary = self.eventsList.first {
            if let idEvent = currentEventDictionary.objectForKey("id") as? String {
                self.fetchGraphApiEvent(idEvent, blockCompletionEvent: { (event) -> Void in
                    if let event = event {
                        self.objectsEventsList.append(event)
                        self.eventsId.append(idEvent)
                    }
                    self.eventsList.removeAtIndex(0)
                    self.fetchEvent()
                })
            }
            else {
                self.eventsList.removeAtIndex(0)
                self.fetchEvent()
            }
        }
        else {
            self.checkAndUpdateFacebookEvent({ () -> () in
                self.blockCompletion(events: self.objectsEventsList)
            })
            return
        }
    }
    
    private func fetchEvents() {
        self.fetchGraphApiEvents { (success) -> Void in
            if !success {
                self.blockCompletion(events: nil)
            }
            self.fetchEvent()
        }
    }
    
    class func fetchEvents(blockCompletion:((events: [Event]?) -> Void)) {
        println("fetch event facebook called")
        self.sharedInstance.blockCompletion = blockCompletion
        self.sharedInstance.eventsList.removeAll(keepCapacity: true)
        self.sharedInstance.objectsEventsList.removeAll(keepCapacity: true)
        self.sharedInstance.eventsId.removeAll(keepCapacity: true)
        self.sharedInstance.fetchEvents()
    }
}

//Extension to fetch information relative to facebook event.
extension FacebookKit {

    private func fetchGraphApiEvents(blockCompletionEvent: ((success: Bool) -> Void)) {
        let requestGraph = FBSDKGraphRequest(graphPath: "me/events", parameters: nil, HTTPMethod: "GET")
        requestGraph.startWithCompletionHandler { (_, result: AnyObject!, error: NSError!) -> Void in
            if error != nil {
                blockCompletionEvent(success: false)
            }
            
            if let result = result as? NSDictionary, let events = result.objectForKey("data") as? [NSDictionary] {
                self.eventsList = events
                
                println("fetched events : \(self.eventsList)")
                blockCompletionEvent(success: true)
                return
            }
            blockCompletionEvent(success: false)
        }
    }
    
    private func fetchGraphApiEvent(idEvent: String, blockCompletionEvent: ((event: Event?) -> Void)) {
        let requestGraph = FBSDKGraphRequest(graphPath: "/\(idEvent)", parameters: nil, HTTPMethod: "GET")
        requestGraph.startWithCompletionHandler { (_, result: AnyObject!, error: NSError!) -> Void in
            if error != nil {
                blockCompletionEvent(event: nil)
            }

            if let result = result as? NSDictionary {
                let newEvent = Event(json: result)
                println("new event created : \(idEvent)")
                self.fetchCoverPhotoEvent(idEvent, blockCompletionCover: { (image) -> Void in
                    newEvent.pictureCover = image
                    blockCompletionEvent(event: newEvent)
                    return
                })
            }
            else {
                blockCompletionEvent(event: nil)
            }
        }
    }
    
    private func fetchCoverPhotoEvent(idEvent: String, blockCompletionCover: ((image: PFFile?) -> Void)) {
        println("try fetch cover image")
        let requestGraph = FBSDKGraphRequest(graphPath: "/\(idEvent)?fields=cover", parameters: nil, HTTPMethod: "GET")
        requestGraph.startWithCompletionHandler { (_, result: AnyObject!, error: NSError!) -> Void in
            if error != nil {
                println("cover error : \(error))")
                blockCompletionCover(image: nil)
                return
            }
            if let resultCover = result as? NSDictionary,
                cover = resultCover.objectForKey("cover") as? NSDictionary,
                coverSourceUrl = cover.objectForKey("source") as? String {
                    ImageDownloader.download(coverSourceUrl, blockCompletion: { (image) -> Void in
                        println("get image cover")
                        if let image = image {
                            let fileCover = PFFile(data: UIImageJPEGRepresentation(image, 0.5))
                            fileCover.saveInBackgroundWithBlock({ (_, _) -> Void in
                                println("result cover image : \(fileCover)")
                                blockCompletionCover(image: fileCover)
                            })
                        }
                        else {
                            blockCompletionCover(image: nil)
                        }
                    })
            }
            else {
                blockCompletionCover(image: nil)
            }
        }
    }
}

//Facebook events interaction with Parse API objects
extension FacebookKit {
    
    private func checkAndUpdateFacebookEvent(blockCompletion: (() -> ())) {
        println("check and update facebook events.")
        var eventsFacebook = self.objectsEventsList
        let querry = PFQuery(className: "Event")
        
        querry.whereKey("facebookEvent", containedIn: eventsId)
        querry.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
            if error != nil {
                return
            }
            
            if let events = results as? [PFObject] {
                for currentEvent in events {
                    for var index = 0; index < eventsFacebook.count; index++ {
                        let currentFacebookItem = eventsFacebook[index]
                        
                        if currentFacebookItem.id == currentEvent["facebookEvent"] as? String {
                            self.checkJoinFacebookEvent(currentEvent)
                            eventsFacebook.removeAtIndex(index)
                            break
                        }
                    }
                }
            }
        }
    }
    
    private func checkJoinFacebookEvent(event: PFObject) {
        let querry = PFQuery(className: "Participant")
        querry.whereKey("eventId", equalTo: event)
        querry.whereKey("userId", equalTo: PFUser.currentUser()!)
        
        querry.findObjectsInBackgroundWithBlock { (result: [AnyObject]?, err: NSError?) -> Void in
            if err != nil {
                return
            }
            if result?.count == 0 {
                self.joinFacebookEvent(event)
            }
        }
    }
    
    private func addRelationFacebookEventToUser(event: PFObject) {
        let relation = PFUser.currentUser()?.relationForKey("facebookEvents")
        relation?.addObject(event)
        PFUser.currentUser()?.saveInBackgroundWithBlock({ (_, _) -> Void in })
    }
    
    private func joinFacebookEvent(event: PFObject) {
        let newParticipant = PFObject(className: "Participant")
        newParticipant["eventId"] = event
        newParticipant["userId"] = PFUser.currentUser()!
        newParticipant["approval"] = true
        newParticipant["invited"] = false
        newParticipant["status"] = "accepted"
        
        newParticipant.saveInBackgroundWithBlock { (_, err: NSError?) -> Void in
            if err == nil {
                self.addRelationFacebookEventToUser(event)
            }
            if let numberParticipant = event["nbParticipant"] as? Int {
                event["nbParticipant"] = numberParticipant + 1
                event.saveInBackgroundWithBlock({ (_, _) -> Void in})
            }
        }
    }
}
