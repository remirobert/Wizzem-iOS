//
//  FeedWizzViewController.swift
//  
//
//  Created by Remi Robert on 20/06/15.
//
//

import UIKit
import Parse
import SwiftMoment

class FeedWizzViewController: UITableViewController, UITableViewDataSource {

    var events = Array<PFObject>()
    var eventsClass = NSMutableDictionary()
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 93
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return eventsClass.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentEvent = eventsClass.allKeys[section] as! String
        return eventsClass[currentEvent]!.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let currentEvent = eventsClass.allKeys[section] as! String
        return currentEvent
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("feedWizzCell") as? FeedEventCollectionViewCell
        
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("FeedEventCollectionViewCell", owner: self, options: nil).first as? FeedEventCollectionViewCell
        }
        
        let currentEventKey = eventsClass.allKeys[indexPath.section] as! String
        if let currentEvent = eventsClass[currentEventKey]![indexPath.row] as? PFObject {
            cell!.titleWizzLabel.text = currentEvent.objectForKey("title") as? String
            
            if let startDate = currentEvent.objectForKey("start") as? NSDate {
                let stringDate = moment(startDate, timeZone: NSTimeZone(), locale: NSLocale.currentLocale()).format(dateFormat: "HH:mm")
                cell!.startEventLabel.text = stringDate
            }
            
            if let city = currentEvent.objectForKey("city") as? String {
                cell!.adresseEventLabel.text = city
            }
            
            if let creator = currentEvent.objectForKey("creator") as? PFUser {
                
                let querry = PFUser.query()
                querry!.cachePolicy = PFCachePolicy.CacheElseNetwork
                
                querry!.whereKey("objectId", equalTo: creator.objectId as! AnyObject)
                querry!.findObjectsInBackgroundWithBlock({ (result: [AnyObject]?, err: NSError?) -> Void in
                    
                    if let creatorUser = result?.first as? PFUser {
                        if let username = creatorUser.objectForKey("true_username") as? String {
                            cell!.authorUsernameLabel.text = username
                        }
                        else {
                            cell!.authorUsernameLabel.text = ""
                        }
                    }
                })
            }
        }
        
        return cell!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        
        let query = PFQuery(className: "Event")
        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        
        query.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, err: NSError?) -> Void in
            if let results = results {

                self.events = results as! [PFObject]
                self.eventsClass.removeAllObjects()

                for currentEvent in self.events {
                    if let stringSection = currentEvent.objectForKey("start") as? NSDate {
                        let stringDate = moment(stringSection, timeZone: NSTimeZone(), locale: NSLocale.currentLocale()).format(dateFormat: "dd / MM")

                        if let eventsForDate = self.eventsClass[stringDate] as? NSMutableArray {
                            eventsForDate.addObject(currentEvent)
                        }
                        else {
                            self.eventsClass[stringDate] = NSMutableArray()
                            self.eventsClass[stringDate]?.addObject(currentEvent)
                        }
                    }
                }
                
                
                self.tableView.reloadData()
            }
        }
    }
}
