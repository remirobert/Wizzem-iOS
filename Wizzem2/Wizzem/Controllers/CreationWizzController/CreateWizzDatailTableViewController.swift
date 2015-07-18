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
    
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    
    @IBAction func nextCreationWizz(sender: AnyObject) {
        if titleTextField.text == nil || count(titleTextField.text) == 0 {
            Alert.error("Vous devez spécifier un titre à votre moment.")
            return
        }
        performSegueWithIdentifier(SEGUE_NEXT_CREATION_WIZZ, sender: nil)
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
    
    
    @IBAction func dismissController(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_NEXT_CREATION_WIZZ {
            if let controller = segue.destinationViewController as? CreationWizzPeopleTableViewController {
                
                controller.titleWizz = titleTextField.text
                controller.descriptionWizz = descriptionTextView.text
            }
        }
    }
}
