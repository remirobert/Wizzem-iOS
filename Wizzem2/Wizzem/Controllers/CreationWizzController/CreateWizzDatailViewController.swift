//
//  CreateWizzDatailTableViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 14/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftMoment
import AddressBookUI
import Parse
import MBProgressHUD

class CreateWizzDatailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var labelDetailSwitch: UILabel!
    @IBOutlet var privacySwitch: UISwitch!
    @IBOutlet var createButton: UIButton!
    
    var blockEndCreationMoment: ((moment: PFObject?) -> Void)!
    
    @IBAction func changePrivacy(sender: AnyObject) {
        if privacySwitch.on {
            labelDetailSwitch.text = "Visible par tous"
        }
        else {
            labelDetailSwitch.text = "Visible avec lien"
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
        
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.masksToBounds = true
    }    
}

extension CreateWizzDatailViewController {
    
    func createMoment() {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        var wizz = PFObject(className: "Event")
        wizz["title"] = titleTextField.text!
        wizz["description"] = descriptionTextView.text
        wizz["creator"] = PFUser.currentUser()
        wizz["public"] = privacySwitch.on
        wizz["author_approval"] = true
        wizz["nbMedia"] = 0
        wizz["nbMaxParticipant"] = 0
        wizz["closed"] = false
        wizz["nbParticipant"] = 1
        
        wizz.saveInBackgroundWithBlock { (_, error: NSError?) -> Void in
            if let error = error {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                Alert.error("Erreur lors de la creation de votre moment.")
                return
            }
            self.addParticipant(wizz)
        }
    }
    
    func addParticipant(moment: PFObject) {
        let params = NSMutableDictionary()
        params.setValue(moment.objectId!, forKey: "eventId")
        params.setValue(PFUser.currentUser()?.objectId, forKey: "userId")
        params.setValue("accepted", forKey: "status")
        params.setValue(true, forKey: "approval")
        params.setValue(false, forKey: "invited")
        
        PFCloud.callFunctionInBackground("ParticipantAdd", withParameters: params as [NSObject : AnyObject], block: { (result: AnyObject?, error: NSError?) -> Void in
            
            if let error = error {
                println("error : \(error)")
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                Alert.error("Erreur survenie lors de la création de votre moment.")
                return
            }
            self.blockEndCreationMoment(moment: moment)
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
}
