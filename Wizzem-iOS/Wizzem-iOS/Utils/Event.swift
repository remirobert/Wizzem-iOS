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
    var start: String!
    var coverPhoto: String!
    var position: PFGeoPoint!
    
    init(json: NSDictionary) {
        super.init()
        
        self.id = json.objectForKey("id") as! String
        self.location = json.objectForKey("location") as! String
        self.title = json.objectForKey("name") as! String
        self.descriptioEvent = json.objectForKey("description") as! String
        if let owner = json.objectForKey("owner") as? NSDictionary {
            self.author = owner.objectForKey("name") as! String
            self.idAuthor = owner.objectForKey("id") as! String
        }
        self.start = json.objectForKey("start_time") as! String
        self.coverPhoto = ""
        
        NSLog("json current Event : \(json)")
        
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
