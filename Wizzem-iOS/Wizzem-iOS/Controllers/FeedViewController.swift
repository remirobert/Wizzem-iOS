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
    var querryFetchWizzenEvent: PFQuery!
    var querryFetchFacebookEvent: PFQuery!
    @IBOutlet var segmentData: UISegmentedControl!
    
    @IBAction func changeSegment(sender: AnyObject) {
        self.events.removeAll(keepCapacity: true)
        self.tableView.reloadData()
        if self.segmentData.selectedSegmentIndex == 0 {
            self.querryFetchWizzenEvent.cancel()
            self.fetchDataFacebook()
        }
        else {
            self.querryFetchFacebookEvent.cancel()
            self.fetchData()
        }
    }
    
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
    
    func fetchDataFacebook() {
        PFGeoPoint.geoPointForCurrentLocationInBackground { (location: PFGeoPoint?, _) -> Void in
            if let location = location {
                self.querryFetchFacebookEvent.cachePolicy = PFCachePolicy.CacheThenNetwork
                //self.querryFetchFacebookEvent.orderByDescending("start")
                self.querryFetchFacebookEvent.whereKey("facebook", equalTo: true)
                self.querryFetchFacebookEvent.whereKey("position", nearGeoPoint: location, withinKilometers: 25)
                
                self.querryFetchFacebookEvent.findObjectsInBackgroundWithBlock({ (results: [AnyObject]?, _) -> Void in

                    if self.refreshControl.refreshing {
                        self.refreshControl.endRefreshing()
                    }

                    println("result : \(results)")
                    if let results = results as? [PFObject] {
                        self.events = results
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    func fetchData() {
        PFGeoPoint.geoPointForCurrentLocationInBackground { (location: PFGeoPoint?, _) -> Void in
            if let location = location {
                self.querryFetchWizzenEvent.cachePolicy = PFCachePolicy.CacheThenNetwork
                self.querryFetchWizzenEvent.orderByDescending("updatedAt")
                self.querryFetchWizzenEvent.whereKey("facebook", equalTo: false)
                self.querryFetchWizzenEvent.whereKey("position", nearGeoPoint: location, withinKilometers: 25)
                
                self.querryFetchWizzenEvent.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, _) -> Void in
                    
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
    
    override func viewDidLayoutSubviews() {
        FacebookEvent.fetchEventUser()
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.segmentData.selectedSegmentIndex == 0 {
            self.querryFetchWizzenEvent.cancel()
            self.fetchDataFacebook()
        }
        else {
            self.querryFetchFacebookEvent.cancel()
            self.fetchData()
        }
    }
    
    func displayProfileController() {
        NSNotificationCenter.defaultCenter().postNotificationName("displayFeedController", object: nil)
    }
    
    func refreshContentSpinner() {
        if self.segmentData.selectedSegmentIndex == 0 {
            self.querryFetchWizzenEvent.cancel()
            self.fetchDataFacebook()
        }
        else {
            self.querryFetchFacebookEvent.cancel()
            self.fetchData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.querryFetchFacebookEvent = PFQuery(className: "Event")
        self.querryFetchWizzenEvent = PFQuery(className: "Event")
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshContentSpinner", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor(red:0.3, green:0.85, blue:0.39, alpha:1)
        tableView.addSubview(refreshControl)
        
        tableView.registerNib(UINib(nibName: "MomentFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "momentCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.text = "Autour de moi "
        titleLabel.frame.size = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds) - 40, 40)
        titleLabel.frame.origin = CGPointMake(20, 24)
        titleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 18)!
        self.navigationItem.titleView = titleLabel
        
        let logo = UIButton(frame: CGRectMake(CGRectGetWidth(UIScreen.mainScreen().bounds) - 78, 44 / 2 - 15, 70, 40))
        logo.setImage(UIImage(named: "LogoReverse"), forState: UIControlState.Normal)
        logo.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        logo.backgroundColor = UIColor.clearColor()
        logo.addTarget(self, action: "displayProfileController", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationController?.navigationBar.addSubview(logo)

        
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
