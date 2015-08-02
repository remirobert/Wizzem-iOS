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
    lazy var headerViewCell: HeaderProfileView! = {
        let header = NSBundle.mainBundle().loadNibNamed("HeaderProfile", owner: self, options: nil).first as! HeaderProfileView
        return header
    }()
    
    @IBAction func swipeCameraController(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("swipControllerCamera", object: nil)
    }
    
    func editProfile() {
        self.performSegueWithIdentifier("changeProfileSettingSegue", sender: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("momentCell") as! MomentTableViewCell

        let currentEvent = events[indexPath.row]
        cell.titleMomentLabel.text = currentEvent["title"] as? String
        if let numberUser = currentEvent["nbParticipant"] as? Int {
            cell.participantLabel.text = "Avec \(numberUser) participants."
        }
        return cell
    }
    
    func fetchData() {
        PFCloud.callFunctionInBackground("EventGetParticipating", withParameters: nil) { (result: AnyObject?, err: NSError?) -> Void in
            if let result = result as? [PFObject] {
                self.events = result
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 113
    }
    
    override func viewDidAppear(animated: Bool) {
        headerViewCell.usernameLabel.text = PFUser.currentUser()!["true_username"] as? String
        if let file = PFUser.currentUser()!["picture"] as? PFFile {
            file.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                if let data = data {
                    self.headerViewCell.profileImageView.image = UIImage(data: data)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let logo = UIImageView(frame: CGRectMake(8, 44 / 2 - 15, 70, 30))
        logo.image = UIImage(named: "LogoWz")
        logo.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.addSubview(logo)

        let titleLabel = UILabel()
        titleLabel.textAlignment = NSTextAlignment.Right
        titleLabel.text = "Profile  "
        titleLabel.frame.size = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds) - 40, 40)
        titleLabel.frame.origin = CGPointMake(20, 24)
        titleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 18)!
        self.navigationItem.titleView = titleLabel
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        
        headerViewCell.buttonEditProfile.addTarget(self, action: "editProfile", forControlEvents: UIControlEvents.TouchUpInside)
        
        let v = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 100))
        v.backgroundColor = UIColor.redColor()
        headerViewCell.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), 110)
        
        tableView.tableHeaderView = headerViewCell
        
        tableView.registerNib(UINib(nibName: "MomentCell", bundle: nil), forCellReuseIdentifier: "momentCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchData()
    }
}
