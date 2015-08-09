//
//  ProfileViewController.swift
//  
//
//  Created by Remi Robert on 18/07/15.
//
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var events = Array<PFObject>()
    var refreshControl: UIRefreshControl!
    var animator: ZFModalTransitionAnimator!
    @IBOutlet var pictureProfile: FLAnimatedImageView!
    @IBOutlet var usernameLabel: UILabel!
    
    @IBAction func editProfile(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let profileAction = UIAlertAction(title: "Voir mon profile", style: UIAlertActionStyle.Default) { (_) -> Void in
            self.performSegueWithIdentifier("detailProfileSegue", sender: nil)
        }
        let logoutAction = UIAlertAction(title: "Deconnexion", style: UIAlertActionStyle.Destructive) { (_) -> Void in
            PFUser.logOutInBackgroundWithBlock({ (error: NSError?) -> Void in
                if error != nil {
                    Alert.error("Erreur lors de la deconnexion")
                }
                else {
                    if let controller = InstanceController.fromStoryboard("loginSignupController") {
                        self.presentViewController(controller, animated: false, completion: nil)
                    }
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(profileAction)
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func editProfile() {
        self.performSegueWithIdentifier("changeProfileSettingSegue", sender: nil)
    }
        
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        performSegueWithIdentifier("detailEventSegue", sender: events[indexPath.row])
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
        
        currentEvent.fetchIfNeededInBackgroundWithBlock { (event: PFObject?, _) -> Void in
            if let event = event {
                if let title = event["title"] as? String {
                    cell.titleMoment.text = title
                }
                if let numberParticipant = event["nbParticipant"] as? Int {
                    cell.participantLabel.text = "Avec \(numberParticipant) participants"
                }
                if let wizzNumber = event["nbMedia"] as? Int {
                    cell.wizzLabel.text = "\(wizzNumber)"
                }
                if let city = event["city"] as? String {
                    cell.dataMoment.text = "à \(city)"
                }
            }
        }
        return cell
    }
    
    func fetchData() {
        let querry = PFQuery(className: "Participant")
        querry.whereKey("userId", equalTo: PFUser.currentUser()!)
        
        querry.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, _) -> Void in

            if self.refreshControl.refreshing {
                self.refreshControl.endRefreshing()
            }
            
            if let results = results as? [PFObject] {
                self.events.removeAll(keepCapacity: false)
                for currentParticipant in results {
                    if let event = currentParticipant["eventId"] as? PFObject {
                        self.events.append(event)
                    }
                }
                self.tableView.reloadData()
            }
        }        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 97
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameLabel.text = nil
        self.pictureProfile.image = nil
        self.pictureProfile.contentMode = UIViewContentMode.ScaleAspectFill
        self.pictureProfile.layer.masksToBounds = true
        self.pictureProfile.layer.cornerRadius = 25
        
        PFUser.currentUser()?.fetchInBackgroundWithBlock({ (user: PFObject?, _) -> Void in
            if let user = user {
                self.usernameLabel.text = user["true_username"] as? String
                if let filePicture = user["picture"] as? PFFile {
                    filePicture.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                        if let data = data {
                            if let dataType = user["typePicture"] as? String where dataType == "GIF" {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    let animatedImage = FLAnimatedImage(animatedGIFData: data)
                                    println("aimated image : \(animatedImage)")
                                    self.pictureProfile.animatedImage = animatedImage
                                })
                            }
                            else {
                                self.pictureProfile.image = UIImage(data: data)
                            }
                        }
                    })
                }
            }
        })
    
        let logo = UIImageView(frame: CGRectMake(8, 44 / 2 - 15, 70, 30))
        logo.image = UIImage(named: "LogoWz")
        logo.backgroundColor = UIColor.clearColor()
        logo.contentMode = UIViewContentMode.ScaleAspectFit
        self.navigationController?.navigationBar.addSubview(logo)

        let titleLabel = UILabel()
        titleLabel.textAlignment = NSTextAlignment.Right
        titleLabel.text = "Mes moments "
        titleLabel.frame.size = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds) - 40, 40)
        titleLabel.frame.origin = CGPointMake(20, 24)
        titleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 18)!
        self.navigationItem.titleView = titleLabel
        
        let v = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 100))
        v.backgroundColor = UIColor.redColor()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor(red:0.3, green:0.85, blue:0.39, alpha:1)
        tableView.addSubview(refreshControl)
        
        tableView.registerNib(UINib(nibName: "MomentFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "momentCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchData()
        
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
        else if segue.identifier == "detailProfileSegue" {
            (segue.destinationViewController as! DetailProfileViewController).user = PFUser.currentUser()!
        }
    }
}
