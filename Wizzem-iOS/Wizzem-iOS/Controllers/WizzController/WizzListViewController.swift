//
//  WizzListViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 14/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class WizzListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var events = Array<PFObject>()
    var completionSelection: ((event: PFObject) -> ())?
    var file: PFFile!
    var type: String!

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let event = events[indexPath.row]
        self.addMedia(event)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("wizzCell") as! LastWizzMomentTableViewCell
        
        cell.title.text = nil
        cell.date.text = nil
        
        var currentEvent = events[indexPath.row]
        
        currentEvent.fetchIfNeededInBackgroundWithBlock { (event: PFObject?, _) -> Void in
            if let event = event {
                if let titleEvent = event["title"] as? String {
                    cell.title.text = titleEvent
                }
                
                if let date = event.createdAt {
                    let formatString = date.formattedDateWithFormat("EEE, MMM d")
                    let formatStringHour = date.formattedDateWithFormat("h:mm")
                    cell.date.text = "Créé le \(formatString) à \(formatStringHour)"
                }
            }
        }
        return cell
    }
    
    @IBAction func dismissController(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()

        let querry = PFQuery(className: "Participant")
        querry.whereKey("userId", equalTo: PFUser.currentUser()!)
        
        querry.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, _) -> Void in
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createMomentSegue" {
            
            let navigationController = segue.destinationViewController as! UINavigationController
        
            let controller = navigationController.viewControllers.first as! CreateWizzDatailViewController
            
            controller.blockEndCreationMoment = {(moment: PFObject?) -> Void in
                if let moment = moment {
                    self.addMedia(moment)
                }
            }
        }
    }
}

extension WizzListViewController {
    func addMedia(currentEvent: PFObject) {

        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Upload de votre media."
        hud.dimBackground = true

        self.file.saveInBackgroundWithBlock { (_, err: NSError?) -> Void in
            
            if err != nil {
                hud.hide(true)
                Alert.error("Vous devez selectionnez ou créer un moment avant de publier.")
                return
            }
            
            let params = NSMutableDictionary()
            
            params.setValue(currentEvent.objectId!, forKey: "eventId")
            params.setValue(PFUser.currentUser()!.objectId!, forKey: "userId")
            params.setValue(self.file, forKey: "file")
            params.setValue(self.type, forKey: "type")
            
            PFCloud.callFunctionInBackground("MediaAdd", withParameters: params as [NSObject : AnyObject]) { (media: AnyObject?, error: NSError?) -> Void in
                hud.hide(true)
                if let error = error {
                    println("error : \(error)")
                    Alert.error("Erreur lors de l'uplaod de votre Wizz.")
                }
                else {
                    let username = (PFUser.currentUser()!["true_username"] as? String)!
                    let nameEvent = (currentEvent["title"] as? String)!
                    let message = "\(username) à publier un nouveau média dans \(nameEvent)."
                    
                    println("message : \(message)")
                    
                    if let media = media as? PFObject {
                        media["creationDate"] = NSDate()
                        
                        media.saveInBackgroundWithBlock({ (_, error: NSError?) -> Void in
                            if error == nil {
                                ProgressionData.completeDataProgression()
                                PushNotification.pushNotification("c\(currentEvent.objectId!)", message: message)
                                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                                    NSNotificationCenter.defaultCenter().postNotificationName("dismissCameraController", object: nil)
                                })
                            }
                            else {
                                Alert.error("Erreur lors de l'uplaod de votre Wizz.")
                                return
                            }
                        })
                    }
                }
            }
        }
    }
}
