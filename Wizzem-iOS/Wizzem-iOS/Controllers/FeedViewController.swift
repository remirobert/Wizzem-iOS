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
    var sections = NSMutableDictionary()
    var sortDaysSection = Array<String>()
    
    lazy var backgroundTableView: UIImageView! = {
        let view = UIImageView(frame: UIScreen.mainScreen().bounds)
        view.contentMode = UIViewContentMode.ScaleAspectFill
        return view
    }()
    
    @IBOutlet var segmentData: UISegmentedControl!
    
    @IBAction func changeSegment(sender: AnyObject) {
        self.events.removeAll(keepCapacity: true)
        self.tableView.reloadData()
        if self.segmentData.selectedSegmentIndex == 0 {
            self.backgroundTableView.image = UIImage(named: "EventFB")
            self.querryFetchWizzenEvent.cancel()
            self.fetchDataFacebook()
        }
        else {
            self.backgroundTableView.image = UIImage(named: "GroupeWz")
            self.querryFetchFacebookEvent.cancel()
            self.fetchData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.segmentData.selectedSegmentIndex == 0 {
            return self.sections.count
        }
        else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        var selectedEvent: PFObject?
        
        if self.segmentData.selectedSegmentIndex == 0 {
            if let eventsArray = self.sections.objectForKey(self.sortDaysSection[indexPath.section]) as? NSMutableArray,
                event = eventsArray.objectAtIndex(indexPath.row) as? PFObject {
                    selectedEvent = event
            }
        }
        else {
            selectedEvent = events[indexPath.row]
        }
        if let selectedEvent = selectedEvent {
            performSegueWithIdentifier("detailEventSegue", sender: selectedEvent)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 206
        }
        return 97
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentData.selectedSegmentIndex == 0 {
            if let events = self.sections.objectForKey(self.sortDaysSection[section]) as? NSMutableArray {
                return events.count
            }
        }
        return events.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.segmentData.selectedSegmentIndex == 0 {
            return 50
        }
        return  0
    }
        
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.segmentData.selectedSegmentIndex == 0 {
            if let header = UINib(nibName: "HeaderSectionEventView", bundle: nil).instantiateWithOwner(self, options: nil).first as? HeaderSectionEventView {
                header.labelDate.text = self.sortDaysSection[section]
                return header
            }
        }
        return nil
    }
    
    //TODO : Make a protocole for the moment cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if indexPath.row != 1 {
            cell = tableView.dequeueReusableCellWithIdentifier("momentCell") as! MomentFeedTableViewCell
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("momentCellCover") as! DatilMomentWithCoverTableViewCell
        }

        var currentEvent: PFObject!
        
        if self.segmentData.selectedSegmentIndex == 0 {
            if let eventsArray = self.sections.objectForKey(self.sortDaysSection[indexPath.section]) as? NSMutableArray,
                event = eventsArray.objectAtIndex(indexPath.row) as? PFObject {
                currentEvent = event
            }
        }
        else {
            currentEvent = events[indexPath.row]
        }
        
        if currentEvent == nil {
            return cell
        }
        
        (cell as! MomentCellProtocol).titleMoment.text = nil
        (cell as! MomentCellProtocol).participantLabel.text = nil
        (cell as! MomentCellProtocol).wizzLabel.text = nil
        (cell as! MomentCellProtocol).dataMoment.text = nil
        
        if let title = currentEvent["title"] as? String {
            (cell as! MomentCellProtocol).titleMoment.text = title
        }
        if let numberParticipant = currentEvent["nbParticipant"] as? Int {
            (cell as! MomentCellProtocol).participantLabel.text = "Avec \(numberParticipant) participants"
        }
        if let wizzNumber = currentEvent["nbMedia"] as? Int {
            (cell as! MomentCellProtocol).wizzLabel.text = "\(wizzNumber)"
        }
        if let city = currentEvent["city"] as? String {
            (cell as! MomentCellProtocol).dataMoment.text = "à \(city)"
        }

        if indexPath.row == 1 {
            (cell as! DatilMomentWithCoverTableViewCell).cover.image = UIImage(named: "Cover")
            (cell as! DatilMomentWithCoverTableViewCell).cover.layer.masksToBounds = true
            (cell as! DatilMomentWithCoverTableViewCell).coverButton.addTarget(self, action: "displayCoverDetailMoment",
                forControlEvents: UIControlEvents.TouchUpInside)
        }        
        return cell
    }
    
    func initSectionFacebookEvents() {
        self.sections.removeAllObjects()
        self.sortDaysSection.removeAll(keepCapacity: false)
        var dates = Array<NSDate>()
        
        for currentEvent in self.events {
            if let startDate = currentEvent["start"] as? NSDate where startDate.isEarlierThan(NSDate()) {
                var currentDate = startDate.formattedDateWithFormat("EEEE d MMM")
                currentDate = "\(currentDate)"
                
                var eventsDays = self.sections.objectForKey(currentDate) as? NSMutableArray
                if  eventsDays == nil {
                    eventsDays = NSMutableArray()
                    dates.append(startDate)
                    self.sections.setObject(eventsDays!, forKey: currentDate)
                }
                
                eventsDays?.addObject(currentEvent)
            }
        }
        
        dates.sort { (date1, date2) -> Bool in
            if date1.timeIntervalSince1970 < date2.timeIntervalSince1970 {
                return true
            }
            return false
        }
        
        for currentDate in dates {
            var currentDateString = currentDate.formattedDateWithFormat("EEEE d MMM")
            currentDateString = "\(currentDateString)"
            self.sortDaysSection.append(currentDateString)
        }
        
        self.tableView.reloadData()
    }
    
    func fetchDataFacebook() {
        PFGeoPoint.geoPointForCurrentLocationInBackground { (location: PFGeoPoint?, _) -> Void in
            if let location = location {
                self.querryFetchFacebookEvent.cachePolicy = PFCachePolicy.CacheThenNetwork
                self.querryFetchFacebookEvent.orderByDescending("start")
                self.querryFetchFacebookEvent.whereKey("public", equalTo: true)
                self.querryFetchFacebookEvent.whereKey("facebook", equalTo: true)
                 self.querryFetchFacebookEvent.whereKey("position", nearGeoPoint: location, withinKilometers: 25)
                
                self.querryFetchFacebookEvent.findObjectsInBackgroundWithBlock({ (results: [AnyObject]?, _) -> Void in

                    if self.refreshControl.refreshing {
                        self.refreshControl.endRefreshing()
                    }

                    println("result : \(results)")
                    if let results = results as? [PFObject] {
                        self.events = results
                        self.initSectionFacebookEvents()
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
                self.querryFetchWizzenEvent.whereKey("public", equalTo: true)
                self.querryFetchWizzenEvent.whereKey("facebook", equalTo: false)
                self.querryFetchWizzenEvent.whereKey("position", nearGeoPoint: location, withinKilometers: 25)
                
                self.querryFetchWizzenEvent.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, _) -> Void in
                    
                    if self.refreshControl.refreshing {
                        self.refreshControl.endRefreshing()
                    }
                    
                    if let results = results as? [PFObject] {
                        if results.count == 0 {
                            self.backgroundTableView.image = UIImage(named: "AucunMoment")
                        }
                        else {
                            if self.segmentData.selectedSegmentIndex == 0 {
                                self.backgroundTableView.image = UIImage(named: "EventFB")
                            }
                            else {
                                self.backgroundTableView.image = UIImage(named: "GroupeWz")
                            }
                        }
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
    
    func displayCoverDetailMoment() {
        self.performSegueWithIdentifier("detailCoverSegue", sender: nil)
    }
    
    func refreshContentSpinner() {
        if self.segmentData.selectedSegmentIndex == 0 {
            Wait🕟Block.executeBlock("eventFacebook", limitTimer: 20, completionBlock: { () -> Void in
                FacebookKit.fetchEvents { (events) -> Void in
                    println("result events fetched by facebook : \(events)")
                }
                //FacebookEvent.fetchEventUser()
            })
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
        
        self.tableView.backgroundView = self.backgroundTableView
        self.backgroundTableView.image = UIImage(named: "EventFB")

        FacebookKit.fetchEvents { (events) -> Void in
            println("result events fetched by facebook : \(events)")
        }
        
        //FacebookEvent.fetchEventUser()
        
        self.querryFetchFacebookEvent = PFQuery(className: "Event")
        self.querryFetchWizzenEvent = PFQuery(className: "Event")
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshContentSpinner", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor(red:0.3, green:0.85, blue:0.39, alpha:1)
        tableView.addSubview(refreshControl)
        
        tableView.registerNib(UINib(nibName: "MomentFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "momentCell")
        tableView.registerNib(UINib(nibName: "DatilMomentWithCoverTableViewCell", bundle: nil), forCellReuseIdentifier: "momentCellCover")
        
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
        else if segue.identifier == "detailCoverSegue" {
            (segue.destinationViewController as! DetailCoverViewController).imageCover = UIImage(named: "Cover")
            
            let controller = segue.destinationViewController as! UIViewController
            
            self.animator = ZFModalTransitionAnimator(modalViewController: controller)
            self.animator.dragable = true
            self.animator.bounces = false
            self.animator.behindViewAlpha = 0.5
            self.animator.behindViewScale = 0.9
            self.animator.transitionDuration = 0.7
            controller.transitioningDelegate = self.animator
        }
    }

}
