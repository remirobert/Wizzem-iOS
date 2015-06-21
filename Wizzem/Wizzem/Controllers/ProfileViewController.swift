//
//  ProfileViewController.swift
//  
//
//  Created by Remi Robert on 19/06/15.
//
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var headerViewProfile: ProfileHeaderView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("detailCell") as! UITableViewCell
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 59
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let viewHeader = NSBundle.mainBundle().loadNibNamed("HeaderSectionProfileView", owner: self, options: nil).first as? HeaderSectionProfileView {
            return viewHeader
        }
        return nil
    }

    override func viewDidLayoutSubviews() {
        tableView.tableHeaderView = headerViewProfile
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        headerViewProfile = NSBundle.mainBundle().loadNibNamed("ProfilerHeaderView", owner: self, options: nil).first as! ProfileHeaderView
        
        if let username = PFUser.currentUser()?.objectForKey("true_username") as? String {
            headerViewProfile.usernameLabel.text = username
        }
        if let nbFollower = PFUser.currentUser()?.objectForKey("nbFollower") as? Int {
            headerViewProfile.followersLabel.text = "\(nbFollower)"
        }
        if let nbFollowing = PFUser.currentUser()?.objectForKey("nbFollowing") as? Int {
            headerViewProfile.followersLabel.text = "\(nbFollowing)"
        }
        if let fileImage = PFUser.currentUser()?.objectForKey("picture") as? PFFile {
            fileImage.getDataInBackgroundWithBlock({ (data: NSData?, err: NSError?) -> Void in
                if let dataImage = data, let image = UIImage(data: dataImage) {
                    self.headerViewProfile.profilePicture.image = image
                }
            })
        }
        headerViewProfile.frame.size.height = 102

        WizzemAPI.getMyEvents { (result, events) -> () in
            switch result {
            case .👍:break
            case .👎(_, let error): break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
