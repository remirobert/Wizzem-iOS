//
//  FacebookEvent.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 02/09/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class FacebookEvent: NSObject {
   
    class func fetchEventUser() {
        println("===================================")
        println("fetch event user")
        var facebookEvents = Array<Event>()
        var eventId = Array<String>()
        var passCount = 0
        
        let requestGraph = FBSDKGraphRequest(graphPath: "me/events", parameters: nil, HTTPMethod: "GET")
        requestGraph.startWithCompletionHandler({ (connection: FBSDKGraphRequestConnection!, result: AnyObject!, err: NSError!) -> Void in
            if let result = result as? NSDictionary, let events = result.objectForKey("data") as? [NSDictionary] {
                println("events : \(events)")
                println("COUNT EVENTS : \(events.count)")
                
                for currentEvent in events {
                    if let idEvent = currentEvent.objectForKey("id") as? String {
                        let requestEventGraph = FBSDKGraphRequest(graphPath: "/\(idEvent)", parameters: nil, HTTPMethod: "GET")
                        requestEventGraph.startWithCompletionHandler({ (connection: FBSDKGraphRequestConnection!, result: AnyObject!, err: NSError!) -> Void in
                            if let result = result as? NSDictionary {
                                println("result : \(result)")

                                let newEvent = Event(json: result)
                                
                                eventId.append(newEvent.id)
                                facebookEvents.append(newEvent)
                                passCount += 1
                                
                                if passCount == events.count {
                                    
                                    var notificationsGroup = Array<String>()
                                    for currentId in eventId {
                                        notificationsGroup.append("c\(currentId)")
                                    }
                                    PushNotification.addNotifications(notificationsGroup)
                                    
                                    self.checkAndUpdateFacebookEvent(eventId, events: facebookEvents)
                                }

                                
//                                let requestPhoto = FBSDKGraphRequest(graphPath: "/\(idEvent)?fields=cover", parameters: nil, HTTPMethod: "GET")
//                                requestPhoto.startWithCompletionHandler({ (_, resultCover: AnyObject!, err: NSError!) -> Void in
//                                    println("content cover : \(resultCover)")
//                                    
//                                    if let resultCover = resultCover as? NSDictionary,
//                                        cover = resultCover.objectForKey("cover") as? NSDictionary,
//                                        coverSourceUrl = cover.objectForKey("source") as? String  {
//                                        newEvent.coverPhoto = coverSourceUrl
//                                    }
//                                    
//                                })
                            }
                        })
                    }
                }
            }
        })
    }
    
    class func checkAndUpdateFacebookEvent(eventsId: [String], events: [Event]) {
        var eventsFacebook = Array<Event>()
        for ev in events {
            eventsFacebook.append(ev)
        }
        let querry = PFQuery(className: "Event")
        querry.whereKey("facebookEvent", containedIn: eventsId)
        
        println("events id : \(eventsId.count) / event : \(events.count)")
        
        querry.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, err: NSError?) -> Void in
            if err != nil {
                println("error \(err)")
                return
            }
            if let results = results as? [PFObject] {
                for result in results {
                    for var index = 0; index < eventsFacebook.count; index++ {
                        let currentFacebookItem = eventsFacebook[index]
                        
                        if currentFacebookItem.id == result["facebookEvent"] as? String {
                            println("REMOVE DOUBLE EVENT : \(currentFacebookItem.title)")
                            self.checkJoinFacebookEvent(result)
                            eventsFacebook.removeAtIndex(index)
                            break
                        }
                    }
                }
            }
            self.createNewFacebookEvent(eventsFacebook)
        }
    }
    
    class func createNewFacebookEvent(events: [Event]) {
        for currentEvent in events {
            let event = PFObject(className: "Event")
            
            event["start"] = currentEvent.start
            event["city"] = currentEvent.location
            event["description"] = currentEvent.descriptioEvent
            event["nbParticipant"] = 0
            event["public"] = currentEvent.publicEvent
            event["title"] = currentEvent.title
            event["nbMedia"] = 0
            event["facebookEvent"] = currentEvent.id
            event["coverUrl"] = currentEvent.coverPhoto
            event["closed"] = false
            event["facebook"] = true
            event["position"] = currentEvent.position
            
            event.saveInBackgroundWithBlock { (_, err: NSError?) -> Void in
                if err != nil {
                    println("error save new facebook event : \(err)")
                }
                else {
                    self.joinFacebookEvent(event)
                }
            }
        }
    }
}

extension FacebookEvent {

    class func addRelationFacebookEventToUser(event: PFObject) {
        let relation = PFUser.currentUser()?.relationForKey("facebookEvents")
        relation?.addObject(event)
        PFUser.currentUser()?.saveInBackgroundWithBlock({ (_, _) -> Void in })
    }
    
    class func joinFacebookEvent(event: PFObject) {
        let newParticipant = PFObject(className: "Participant")
        newParticipant["eventId"] = event
        newParticipant["userId"] = PFUser.currentUser()!
        newParticipant["approval"] = true
        newParticipant["invited"] = false
        newParticipant["status"] = "accepted"
        
        newParticipant.saveInBackgroundWithBlock { (_, err: NSError?) -> Void in
            println("error new participant add : \(err)")
            if err == nil {
                self.addRelationFacebookEventToUser(event)
            }
            if let numberParticipant = event["nbParticipant"] as? Int {
                event["nbParticipant"] = numberParticipant + 1
                event.saveInBackgroundWithBlock({ (_, _) -> Void in})
            }
        }
    }
    
    class func checkJoinFacebookEvent(event: PFObject) {
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
}


