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
    
    var start: NSDate!
    var end: NSDate!
    
    @IBOutlet var titleWizz: UITextField!
    @IBOutlet var startWizz: UITextField!
    @IBOutlet var endWizz: UITextField!
    @IBOutlet var cityWizz: UITextField!
    @IBOutlet var locationInformationWizz: UITextField!
    @IBOutlet var descriptionDetailWizz: UITextView!
    @IBOutlet var switchPrivacyWizz: UISwitch!
    
    @IBAction func changePrivacyWizz(sender: AnyObject) {
    }
    
    @IBAction func nextCreationWizz(sender: AnyObject) {
        if titleWizz.text != "" &&  startWizz.text != "" && endWizz.text != "" && cityWizz.text != "" {
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
        if textField.tag == 10 || textField.tag == 11 {
            
            if textField.tag == 11 && startWizz.text == "" {
                Alert.error("Entrez votre date de début en premier.")
                return false
            }
            
            let cancelAction = RMAction(title: "Cancel", style: RMActionStyle.Cancel, andHandler: { (controller: RMActionController!) -> Void in})
            let selectAction = RMAction(title: "Select", style: RMActionStyle.Done, andHandler: { (controller: RMActionController!) -> Void in
                
                if let date = (controller.contentView as? UIDatePicker)?.date {
                    
                    let stringDate = moment(date, timeZone: NSTimeZone(), locale: NSLocale.currentLocale()).format(dateFormat: "EEE, MMM d à HH:mm")
                    if textField.tag == 10 {
                        self.start = date
                        textField.text = "Début le \(stringDate)"
                        
                        if self.endWizz.text != "" {
                            self.end = nil
                            self.endWizz.text = ""
                            return
                        }
                    }
                    else {
                        self.end = date
                        textField.text = "Fin le \(stringDate)"
                    }
                }
            })
            let dateController = RMDateSelectionViewController(style: RMActionControllerStyle.White, selectAction: selectAction, andCancelAction: cancelAction)
            
            dateController.datePicker.minimumDate = NSDate()
            
            if textField.tag == 11 {
                let dateComponent = NSDateComponents()
                dateComponent.month = 1
                let calendar = NSCalendar.currentCalendar()
                if let endDate = calendar.dateByAddingComponents(dateComponent, toDate: start, options: NSCalendarOptions.allZeros) {
                    dateController.datePicker.maximumDate = endDate
                }
            }
            
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
//        else if textField.tag == 12 {
//            self.performSegueWithIdentifier(SEGUE_SELECT_CITY_WIZZ, sender: nil)
//            return false
//        }
        return true
    }
    
    
    @IBAction func dismissController(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleWizz.delegate = self
        startWizz.delegate = self
        endWizz.delegate = self
        cityWizz.delegate = self
        locationInformationWizz.delegate = self
        descriptionDetailWizz.delegate = self
        
        endWizz.tag = 11
        startWizz.tag = 10
        cityWizz.tag = 12
        
        RRLocationManager.requestAuthorization()
        RRLocationManager.currentAddressLocation { (currentAddress, error) -> () in
            if let currentAddress = currentAddress?.first {
                let city = currentAddress.addressDictionary[kABPersonAddressCityKey] as! String
                self.cityWizz.text = city
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_NEXT_CREATION_WIZZ {
            if let controller = segue.destinationViewController as? CreationWizzPeopleTableViewController {
                var wizz = PFObject(className: "Event")
                
                wizz["title"] = titleWizz.text
                wizz["start"] = start
                wizz["end"] = end
                wizz["city"] = cityWizz.text
                wizz["public"] = switchPrivacyWizz.on
                wizz["nbParticipant"] = 0
                wizz["creator"] = PFUser.currentUser()
                wizz["closed"] = false
                wizz["nbMedia"] = 0
                if locationInformationWizz.text != "" {
                    wizz["location_text"] = locationInformationWizz.text
                }
                if descriptionDetailWizz.text != "" {
                    wizz["description"] = descriptionDetailWizz.text
                }

                controller.wizz = wizz
            }
        }
    }
}
