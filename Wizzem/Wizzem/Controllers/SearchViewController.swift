//
//  SearchViewController.swift
//  
//
//  Created by Remi Robert on 23/06/15.
//
//

import UIKit
import Parse

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    var wizzSearch = Array<PFObject>()
    var userSearch = Array<PFObject>()

    //MARK: UITableView datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControl.selectedSegmentIndex == 0 {
            return wizzSearch.count
        }
        return userSearch.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if segmentControl.selectedSegmentIndex == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("wizzSearchCell") as! UITableViewCell
            let currentItem = wizzSearch[indexPath.row]
            cell.textLabel!.text = currentItem["title"] as? String
            return cell
        }
        
        var cell = tableView.dequeueReusableCellWithIdentifier("userSearchCell") as! UITableViewCell
        let currentItem = userSearch[indexPath.row]
        cell.textLabel!.text = currentItem["true_username"] as? String
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
                self.tableView.reloadData()
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
