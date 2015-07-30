//
//  FeedViewController.swift
//  
//
//  Created by Remi Robert on 10/07/15.
//
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var events = Array<PFObject>()
    @IBOutlet var tableView: UITableView!
    
    @IBAction func swipeCameraController(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("swipControllerCamera", object: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("detailEventSegue", sender: events[indexPath.row])
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("feedEventCell") as! FeedEventTableViewCell
        
        let currentEvent = events[indexPath.row]
        
        if let title = currentEvent["title"] as? String {
            cell.titleWizz.text = title
        }
        if let numberParticipant = currentEvent["nbParticipant"] as? Int {
            cell.participantsWizz.text = "Avec \(numberParticipant) participants"
        }
        
        return cell
    }
    
    func fetchData() {
        let querry = PFQuery(className: "Event")
        querry.cachePolicy = PFCachePolicy.CacheThenNetwork
        querry.orderByAscending("updatedAt")
        
        querry.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, _) -> Void in
            if let results = results as? [PFObject] {
                self.events = results
                self.tableView.reloadData()
            }
        }
        
//        PFGeoPoint.geoPointForCurrentLocationInBackground { (geo: PFGeoPoint?, _) -> Void in
//            if let geo = geo {
//                
//                let params = NSMutableDictionary()
//                params.setValue(geo.latitude, forKey: "lat")
//                params.setValue(geo.longitude, forKey: "lng")
//                
//                PFCloud.callFunctionInBackground("EventAround", withParameters: params as [NSObject : AnyObject], block: { (results: AnyObject?, _) -> Void in
//                    if let results = results as? [PFObject] {
//                        self.events = results
//                        self.tableView.reloadData()
//                    }
//                })
//                
//            }
//            else {
//                Alert.error("Erreur de géolocalisation.")
//            }
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailEventSegue" {
            (segue.destinationViewController as! DetailEventViewController).currentEvent = sender as! PFObject
        }
    }

}
