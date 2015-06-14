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

class CreateWizzDatailTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {

    var switchPrivacy: UISwitch!
    var titleTextView: UITextField!
    var beginDate: UITextField!
    var endDate: UITextField!
    var cityLocation: UITextField!
    var descriptionLocation: UITextField!
    var descriptionWizz: UITextView!
    
    var start: NSDate!
    var end: NSDate!
    
    @IBAction func nextCreationWizz(sender: AnyObject) {
        if titleTextView.text != "" &&  beginDate.text != "" && endDate.text != "" && cityLocation.text != "" {
            self.performSegueWithIdentifier(SEGUE_NEXT_CREATION_WIZZ, sender: nil)
        }
        else {
            Alert.error("Veuillez remplir les champs (Titre, date de début et de fin), afin de pouvoir créer votre Wizz")
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            view.endEditing(true)
            return false
        }
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            view.endEditing(true)
            return false
        }
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.tag == 4 || textField.tag == 6 {
            
            let cancelAction = RMAction(title: "Cancel", style: RMActionStyle.Cancel, andHandler: { (controller: RMActionController!) -> Void in})
            let selectAction = RMAction(title: "Select", style: RMActionStyle.Done, andHandler: { (controller: RMActionController!) -> Void in
                
                if let date = (controller.contentView as? UIDatePicker)?.date {
                    let stringDate = moment(date).format(dateFormat: "dd / MM / yyyy à HH:mm")
                    if textField.tag == 4 {
                        self.start = date
                        textField.text = "Début le \(stringDate)"
                    }
                    else {
                        self.end = date
                        textField.text = "Fin le \(stringDate)"
                    }
                }
            })
            
            let dateController = RMDateSelectionViewController(style: RMActionControllerStyle.White, selectAction: selectAction, andCancelAction: cancelAction)
            
            dateController.datePicker.datePickerMode = UIDatePickerMode.DateAndTime
            dateController.datePicker.locale = NSLocale.currentLocale()
            if textField.tag == 4 {
                dateController.title = "Date de début de votre Wizz"
            }
            else {
                dateController.title = "Date de fin de votre Wizz"
            }
            view.endEditing(true)
            navigationController?.presentViewController(dateController, animated: true, completion: nil)
            return false
        }
        else if textField.tag == 10 {
            return false
        }
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) {
            if let currentView = cell.contentView.viewWithTag(1) as? UISwitch {
                switchPrivacy = currentView
            }
        }
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) {
            if let currentView = cell.contentView.viewWithTag(1) as? UITextField {
                titleTextView = currentView
                titleTextView.delegate = self
            }
        }
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1)) {
            if let currentView = cell.contentView.viewWithTag(4) as? UITextField {
                beginDate = currentView
                beginDate.delegate = self
            }
        }
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 1)) {
            if let currentView = cell.contentView.viewWithTag(6) as? UITextField {
                endDate = currentView
                endDate.delegate = self
            }
        }
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) {
            if let currentView = cell.contentView.viewWithTag(10) as? UITextField {
                cityLocation = currentView
                cityLocation.delegate = self
            }
        }
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 2)) {
            if let currentView = cell.contentView.viewWithTag(1) as? UITextField {
                descriptionLocation = currentView
                descriptionLocation.delegate = self
            }
        }
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 3)) {
            if let currentView = cell.contentView.viewWithTag(1) as? UITextView {
                descriptionWizz = currentView
                descriptionWizz.delegate = self
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RRLocationManager.requestAuthorization()
        RRLocationManager.currentAddressLocation { (currentAddress, error) -> () in
            if let currentAddress = currentAddress?.first {
                let city = currentAddress.addressDictionary[kABPersonAddressCityKey] as! String
                self.cityLocation.text = city
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_NEXT_CREATION_WIZZ {
            if let controller = segue.destinationViewController as? CreationWizzPeopleTableViewController {
                var wizz = PFObject(className: "Event")
                
                wizz["title"] = titleTextView.text
                wizz["start"] = start
                wizz["end"] = end
                wizz["city"] = cityLocation.text
                wizz["public"] = switchPrivacy.on
                wizz["nbParticipant"] = 0
                wizz["creator"] = PFUser.currentUser()
                wizz["closed"] = false
                wizz["nbMedia"] = 0
                if descriptionLocation.text != "" {
                    wizz["location_text"] = descriptionLocation.text
                }
                if descriptionWizz.text != "" {
                    wizz["description"] = descriptionWizz.text
                }
                
                controller.wizz = wizz
            }
        }
    }
}
