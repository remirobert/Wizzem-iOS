//
//  SearchViewController.swift
//  
//
//  Created by Remi Robert on 23/06/15.
//
//

import UIKit
import Parse

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    var wizzSearch = Array<PFObject>()
    var userSearch = Array<PFObject>()
    var friends = Array<PFObject>()

    func isAFriend(currentUser: String) -> Bool {
        for user in friends {
            if user.objectId! == currentUser {
                return true
            }
        }
        return false
    }
    
    //MARK: UITableView datasource
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if segmentControl.selectedSegmentIndex == 0 {
            return 60
        }
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControl.selectedSegmentIndex == 0 {
            return wizzSearch.count
        }
        return userSearch.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if segmentControl.selectedSegmentIndex == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("wizzSearchCell") as! SearchWizzTableViewCell
            let currentItem = wizzSearch[indexPath.row]
            cell.titleWizzLabel.text = currentItem["title"] as? String
            cell.placeWizzLabel.text = currentItem["city"] as? String
            return cell
        }
        
        var cell = tableView.dequeueReusableCellWithIdentifier("userSearchCell") as! SearchProfileTableViewCell
        let currentItem = userSearch[indexPath.row]
        
        
        let isFriendWith = isAFriend(currentItem.objectId!)
        cell.followUnfollowLabel.setTitle(isFriendWith ? "unfollow" : "follow", forState: UIControlState.Normal)

        cell.blockCompletion = {() -> Void in
            var params = NSMutableDictionary()
            
            params.setValue(PFUser.currentUser()?.objectId!, forKey: "userHim")
            params.setValue(currentItem.objectId!, forKey: "userHas")
            
            let c = isFriendWith ? "FriendAdd" : "FriendRemoveByUser"
            print("call cloud functon :  \(c)")
            PFCloud.callFunctionInBackground(!isFriendWith ? "FriendAdd" : "FriendRemoveByUser", withParameters: params as [NSObject : AnyObject], block: { (result: AnyObject?, error: NSError?) -> Void in
                
                print(result)
                print(error)
            })
            print("click button")
        }
        cell.profileImageview.image = nil
        
        cell.usernameLabel.text = currentItem["true_username"] as? String
        if let fileProfileImage = currentItem["picture"] as? PFFile {
            fileProfileImage.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                if let data = data {
                    cell.profileImageview.image = UIImage(data: data)
                }
            })
        }
        
        return cell
    }
    
    //MARK: search Query
    
    func querryWizz() {
        let querry = PFQuery(className: "Event")
        querry.cachePolicy = PFCachePolicy.CacheThenNetwork
        querry.whereKey("title", containsString: searchBar.text)
        
        querry.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
            if let results = results {
                self.wizzSearch.removeAll(keepCapacity: false)
                self.wizzSearch = results as! [PFObject]
                self.tableView.reloadData()
            }
        }
    }
    
    func userQuerry() {
        let querry = PFUser.query()!
        querry.cachePolicy = PFCachePolicy.CacheThenNetwork
        querry.whereKey("true_username", containsString: searchBar.text)
        
        querry.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
            if let results = results {
                self.userSearch.removeAll(keepCapacity: false)
                self.userSearch = results as! [PFObject]
                
                var friends = Array<String>()
                for currentFriend in self.userSearch {
                    if let objId = currentFriend.objectId {
                        friends.append(objId)
                    }
                }
                var params = NSMutableDictionary()
                
                params.setValue(friends, forKey: "friends")
                PFCloud.callFunctionInBackground("FriendAreFriend", withParameters: params as [NSObject : AnyObject], block: { (result: AnyObject?, _) -> Void in
                    if let result: AnyObject = result {
                        self.friends = result as! Array<PFObject>
                        self.tableView.reloadData()
                        print("result friends : \(result)\n")
                        for u in self.friends {
                            print("current friends : \(u.objectId)\n")
                        }
                    }
                })
            }
        }
    }
    
    //MARK: UISearchBar delegate
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("search with : \(searchBar.text)")
        querryWizz()
        userQuerry()
    }
    
    @IBAction func changeSegmentSearch(sender: AnyObject) {
        tableView.reloadData()
    }
    
    //MARK: UIview cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
