//
//  FeedViewController.swift
//  
//
//  Created by Remi Robert on 10/07/15.
//
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var events = Array<PFObject>()
    @IBOutlet var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var animator: ZFModalTransitionAnimator!
    
    @IBAction func swipeCameraController(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("swipControllerCamera", object: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        performSegueWithIdentifier("detailEventSegue", sender: events[indexPath.row])
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 97
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("momentCell") as! MomentFeedTableViewCell
        
        let currentEvent = events[indexPath.row]
        
        cell.titleMoment.text = nil
        cell.participantLabel.text = nil
        cell.wizzLabel.text = nil
        cell.dataMoment.text = nil
        
        if let title = currentEvent["title"] as? String {
            cell.titleMoment.text = title
        }
        if let numberParticipant = currentEvent["nbParticipant"] as? Int {
            cell.participantLabel.text = "Avec \(numberParticipant) participants"
        }
        if let wizzNumber = currentEvent["nbMedia"] as? Int {
            cell.wizzLabel.text = "\(wizzNumber)"
        }
        if let city = currentEvent["city"] as? String {
            cell.dataMoment.text = "à \(city)"
        }

        return cell
    }
    
    func fetchData() {
        PFGeoPoint.geoPointForCurrentLocationInBackground { (location: PFGeoPoint?, _) -> Void in
            if let location = location {
                let querry = PFQuery(className: "Event")
                querry.cachePolicy = PFCachePolicy.CacheThenNetwork
                querry.orderByAscending("updatedAt")
                querry.whereKey("position", nearGeoPoint: location, withinKilometers: 25)
                
                querry.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, _) -> Void in
                    
                    if self.refreshControl.refreshing {
                        self.refreshControl.endRefreshing()
                    }
                    
                    if let results = results as? [PFObject] {
                        self.events.removeAll(keepCapacity: true)
                        for currentEvent in results {
                            if let numberWizz = currentEvent["nbMedia"] as? Int {
                                if numberWizz > 0 {
                                    self.events.append(currentEvent)
                                }
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor(red:0.3, green:0.85, blue:0.39, alpha:1)
        tableView.addSubview(refreshControl)
        
        tableView.registerNib(UINib(nibName: "MomentFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "momentCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let logo = UIImageView(frame: CGRectMake(8, 44 / 2 - 15, 70, 30))
        logo.image = UIImage(named: "LogoWz")
        logo.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.addSubview(logo)
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = NSTextAlignment.Right
        titleLabel.text = "Autour de moi "
        titleLabel.frame.size = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds) - 40, 40)
        titleLabel.frame.origin = CGPointMake(20, 24)
        titleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 18)!
        self.navigationItem.titleView = titleLabel
        
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailEventSegue" {
            (segue.destinationViewController as! DetailMediaViewController).currentEvent = sender as! PFObject
            
            let controller = segue.destinationViewController as! UIViewController
            
            self.animator = ZFModalTransitionAnimator(modalViewController: controller)
            self.animator.dragable = true
            self.animator.bounces = false
            self.animator.direction = ZFModalTransitonDirection.Right
            self.animator.behindViewAlpha = 0.5
            self.animator.behindViewScale = 0.9
            self.animator.transitionDuration = 0.7
            controller.transitioningDelegate = self.animator

        }
    }

}
