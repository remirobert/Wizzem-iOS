//
//  Event.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 03/09/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class Event: NSObject {
   
    var id: String!
    var location: String!
    var title: String!
    var descriptioEvent: String!
    var author: String!
    var idAuthor: String!
    var start: NSDate!
    var coverPhoto: String!
    var position: PFGeoPoint!
    var publicEvent: Bool!
    
    init(json: NSDictionary) {
        super.init()
        
        self.id = json.objectForKey("id") as! String

        if let location = json.objectForKey("location") as? String {
            self.location = location
        }
        self.title = json.objectForKey("name") as! String
        if let description = json.objectForKey("description") as? String {
            self.descriptioEvent = description
        }
        if let owner = json.objectForKey("owner") as? NSDictionary {
            self.author = owner.objectForKey("name") as! String
            self.idAuthor = owner.objectForKey("id") as! String
        }
        self.coverPhoto = ""
        
        if let privacy = json.objectForKey("privacy") as? NSString {
            if privacy.isEqualToString("SECRET") {
                self.publicEvent = false
            }
            else {
                self.publicEvent = true
            }
        }
        
        NSLog("json current Event : \(json)")
        
        self.start = NSDate()
        if let startTimeString = json.objectForKey("start_time") as? String {
            if startTimeString.componentsSeparatedByString("T").count == 2 {
                self.start = NSDate(string: startTimeString, formatString: "YYYY-MM-dd\'T\'HH:mm:ssZZZZZ")
            }
            else {
                self.start = NSDate(string: startTimeString, formatString: "YYYY-MM-dd")
            }
        }
        
        if let venue = json.objectForKey("venue") as? NSDictionary,
            latitude = venue.objectForKey("latitude") as? Float,
            longitude = venue.objectForKey("longitude") as? Float {
            
                let point = PFGeoPoint(latitude: Double(latitude), longitude: Double(longitude))
                self.position = point
        }
        else {
            self.position = PFGeoPoint()
        }
    }
}
