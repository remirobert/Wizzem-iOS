//
//  SignupTableViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 11/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit
import SwiftMoment

class SignupTableViewController: UITableViewController, UITextFieldDelegate {
    
    var completionUpdateFirstName: ((content: String) -> Void)?
    var completionUpdateLastName: ((content: String) -> Void)?
    var completionUpdateEmail: ((content: String) -> Void)?
    var completionUpdatePassword: ((content: String) -> Void)?
    var completionUpdateDate: ((date: NSDate) -> Void)?

    lazy var datePicker: UIDatePicker! = {
        let datePicker = UIDatePicker(frame: CGRectZero)
        datePicker.datePickerMode = UIDatePickerMode.Date
        return datePicker
    }()
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string:
        String) -> Bool {
            
            switch textField.tag {
            case 1: completionUpdateFirstName?(content: textField.text)
            case 2: completionUpdateLastName?(content: textField.text)
            case 3: completionUpdateEmail?(content: textField.text)
            case 4: completionUpdatePassword?(content: textField.text)
            default: Void()
            }
            
            if string == "\n" {
                view.endEditing(true)
                return false
            }
            return true 
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.tag == 5 {
            
            let cancelAction = RMAction(title: "Cancel", style: RMActionStyle.Cancel, andHandler: { (controller: RMActionController!) -> Void in})
            let selectAction = RMAction(title: "Select", style: RMActionStyle.Done, andHandler: { (controller: RMActionController!) -> Void in
                
                if let date = (controller.contentView as? UIDatePicker)?.date {
                    textField.text = "\(date)"
                    self.completionUpdateDate?(date: date)
                }
            })
            let dateController = RMDateSelectionViewController(style: RMActionControllerStyle.White, selectAction: selectAction, andCancelAction: cancelAction)
            dateController.datePicker.datePickerMode = UIDatePickerMode.Date
            dateController.datePicker.locale = NSLocale.currentLocale()
            dateController.title = "Date de naissance"
            
            navigationController?.presentViewController(dateController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    override func viewDidAppear(animated: Bool) {

        for var index = 1; index <= 5; index++ {
            if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) {
                if let textField = cell.contentView.viewWithTag(index) as? UITextField {
                    textField.delegate = self
                }
            }
        }
    }
    
}
