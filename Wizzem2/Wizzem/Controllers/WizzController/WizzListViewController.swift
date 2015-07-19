//
//  WizzListViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 14/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse

class WizzListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var events = Array<PFObject>()
    var completionSelection: ((event: PFObject) -> ())?

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let block = completionSelection {
            let event = events[indexPath.row]
            block(event: event)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("wizzCell") as! LastWizzMomentTableViewCell
        
        var currentEvent = events[indexPath.row]
        println("current event : \(currentEvent)")
        if let titleEvent = currentEvent["title"] as? String {
            cell.title.text = titleEvent
        }
        if let numberUser = currentEvent["nbParticipant"] as? Int {
            cell.numberUsers.text = "\(numberUser)"
        }
        if let numberMedia = currentEvent["nbMedia"] as? Int {
            cell.numberMedia.text = "\(numberMedia)"
        }
        
        if let user = currentEvent["creator"] as? PFUser {
            let username = user["true_username"] as? String
            cell.author.text = username
        }
        
        return cell
    }
    
    @IBAction func dismissController(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        PFCloud.callFunctionInBackground("EventGetParticipating", withParameters: nil) { (result: AnyObject?, err: NSError?) -> Void in
            println("error: \(err)")
            println("result : \(result)")
            
            if let result = result as? [PFObject] {
                self.events = result
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}
