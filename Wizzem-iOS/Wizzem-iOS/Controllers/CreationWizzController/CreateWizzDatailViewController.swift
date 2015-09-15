//
//  CreateWizzDatailTableViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 14/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class CreateWizzDatailViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextView: SZTextView!
    @IBOutlet var labelDetailSwitch: UILabel!
    @IBOutlet var privacySwitch: UISwitch!
    @IBOutlet var createButton: UIButton!
    var media: PFFile!
    var type: String!
    var hud: MBProgressHUD!
    
    var blockEndCreationMoment: ((moment: PFObject?) -> Void)!
    
    @IBAction func changePrivacy(sender: AnyObject) {
        if privacySwitch.on {
            labelDetailSwitch.text = "Public (visible par tous)"
        }
        else {
            labelDetailSwitch.text = "Privé (accessible par lien)"
        }
    }
    
    @IBAction func createMoment(sender: AnyObject) {
        createMoment()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            view.endEditing(true)
            return false
        }
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if count(textField.text) > 0 || count(string) > 0 {
            self.createButton.enabled = true
        }
        if count(textField.text) + count(string) == 0 {
            self.createButton.enabled = false
        }
        if string == "\n" {
            view.endEditing(true)
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if count(textField.text) > 0 {
            self.createButton.enabled = true
        }
        else {
            self.createButton.enabled = false
        }
    }
    
    @IBAction func dismissController(sender: AnyObject) {
        self.blockEndCreationMoment(moment: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createButton.enabled = false
        
        self.titleTextField.delegate = self
        self.descriptionTextView.delegate = self
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}

extension CreateWizzDatailViewController {
    
    func createMoment() {
        self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.dimBackground = true
        self.hud.labelText = "Création du moment"
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (currentLocation:PFGeoPoint?, _) -> Void in
            if let currentLocation = currentLocation {
                
                let location = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
                
                RRLocationManager.reverseGeocodingFromLocation(location, { (address, error) -> () in
                    if let address = address?.first {
                        var wizz = PFObject(className: "Event")
                        wizz["title"] = self.titleTextField.text!
                        wizz["description"] = self.descriptionTextView.text
                        wizz["creator"] = PFUser.currentUser()
                        wizz["public"] = self.privacySwitch.on
                        wizz["author_approval"] = true
                        wizz["nbMedia"] = 0
                        wizz["nbMaxParticipant"] = 0
                        wizz["closed"] = false
                        wizz["nbParticipant"] = 1
                        wizz["position"] = currentLocation
                        wizz["city"] = address.locality
                        wizz["facebook"] = false
                        
                        wizz.saveInBackgroundWithBlock { (_, error: NSError?) -> Void in
                            
                            if let error = error {
                                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                Alert.error("Erreur lors de la creation de votre moment.")
                                return
                            }
                            self.addParticipant(wizz)
                        }
                    }
                    else {
                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                        Alert.error("Erreur lors de la récupération de votre localisation.")
                    }
                })
                
            }
            else {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                Alert.error("Erreur lors de la récupération de votre localisation.")
            }
        }
    }
    
    func addParticipant(moment: PFObject) {
        let params = NSMutableDictionary()
        params.setValue(moment.objectId!, forKey: "eventId")
        params.setValue(PFUser.currentUser()?.objectId, forKey: "userId")
        params.setValue("accepted", forKey: "status")
        params.setValue(true, forKey: "approval")
        params.setValue(false, forKey: "invited")
        
        PushNotification.addNotification("c\(moment.objectId!)")
        
        PFCloud.callFunctionInBackground("ParticipantAdd", withParameters: params as [NSObject : AnyObject], block: { (result: AnyObject?, error: NSError?) -> Void in
            
            if let error = error {
                println("error : \(error)")
                self.hud.hide(true)
                Alert.error("Erreur survenie lors de la création de votre moment.")
                return
            }
            
            self.hud.labelText = "Upload de votre média"
            MediaFile.add(self.media, type: self.type, event: moment, blockCompletion: { (success) -> () in
                self.blockEndCreationMoment(moment: moment)
                self.dismissViewControllerAnimated(false, completion: nil)
            })
        })
    }
}
