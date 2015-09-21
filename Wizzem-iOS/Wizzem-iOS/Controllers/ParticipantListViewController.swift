//
//  ParticipantListViewController.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 09/08/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class ParticipantListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var participantNumber: UILabel!
    var currentMoment: PFObject!
    var participants = Array<PFObject>()
    
    @IBAction func dismissController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func sendInvitation(sender: AnyObject) {
        if let eventId = currentMoment.objectId {
            let activityController = UIActivityViewController(activityItems: ["wizzem://?eventId=\(eventId)"], applicationActivities: nil)
            self.presentViewController(activityController, animated: true, completion: nil)
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let participant = participants[indexPath.row]
        if let author = participant["userId"] as? PFUser {
            self.performSegueWithIdentifier("detailProfileSegue", sender: author)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("participantCell") as! ParticipantTableViewCell
        
        let participant = participants[indexPath.row]
        cell.loadParticipant(participant["userId"] as! PFUser)
        return cell
    }
    
    func fetchParticipant() {
        let querry = PFQuery(className: "Participant")
        querry.whereKey("eventId", equalTo: self.currentMoment)
        
        querry.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, _) -> Void in
            if let results = results as? [PFObject] {
                self.participants = results
                if self.participants.count > 0 {
                    self.participantNumber.text = "\(self.participants.count) participants"
                }
                else {
                    self.participantNumber.text = "\(self.participants.count) participant"
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchParticipant()
        self.participantNumber.text = ""
        self.tableView.registerNib(UINib(nibName: "ParticipantTableViewCell", bundle: nil), forCellReuseIdentifier: "participantCell")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailProfileSegue" {
            (segue.destinationViewController as! DetailProfileViewController).user = sender as! PFObject
        }
    }
}
