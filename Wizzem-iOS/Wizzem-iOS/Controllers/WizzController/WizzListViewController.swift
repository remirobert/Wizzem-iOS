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
        return 63
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("wizzCell") as! LastWizzMomentTableViewCell
        
        cell.title.text = nil
        cell.date.text = nil
        
        var currentEvent = events[indexPath.row]
        println("current event : \(currentEvent)")
        if let titleEvent = currentEvent["title"] as? String {
            cell.title.text = titleEvent
        }
        
        if let date = currentEvent.createdAt {
            cell.date.text = date.description
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
        
        PFCloud.callFunctionInBackground("EventGetParticipating", withParameters: nil) { (result: AnyObject?, err: NSError?) -> Void in
            
            if let result = result as? [PFObject] {
                self.events = result
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createMomentSegue" {
            let controller = segue.destinationViewController as! CreateWizzDatailViewController
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
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geo: PFGeoPoint?, _) -> Void in
            if let geo = geo {
                self.file.saveInBackgroundWithBlock { (_, err: NSError?) -> Void in
                    
                    if err != nil {
                        Alert.error("Vous devez selectionnez ou créer un moment avant de publier.")
                        return
                    }
                    
                    let params = NSMutableDictionary()

                    params.setValue(currentEvent.objectId!, forKey: "eventId")
                    params.setValue(PFUser.currentUser()!.objectId!, forKey: "userId")
                    params.setValue(self.file, forKey: "file")
                    params.setValue(geo, forKey: "location")
                    params.setValue(self.type, forKey: "type")
                    
                    PFCloud.callFunctionInBackground("MediaAdd", withParameters: params as [NSObject : AnyObject]) { (_, error: NSError?) -> Void in
                        if let error = error {
                            println("error : \(error)")
                            Alert.error("Erreur lors de l'uplaod de votre Wizz.")
                        }
                        else {
                            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                                NSNotificationCenter.defaultCenter().postNotificationName("dismissCameraController", object: nil)
                            })
                        }
                    }
                }
            }
            else {
                Alert.error("Erreur, lors de la récupération de votre géolocalisation.")
                return
            }
        }
    }
}
