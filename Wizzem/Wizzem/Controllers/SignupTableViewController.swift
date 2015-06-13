//
//  SignupTableViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 11/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class SignupTableViewController: UITableViewController, UITextFieldDelegate {
    
    var completionUpdateFirstName: ((content: String) -> Void)?
    var completionUpdateLastName: ((content: String) -> Void)?
    var completionUpdateEmail: ((content: String) -> Void)?
    var completionUpdatePassword: ((content: String) -> Void)?

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
            
            let dateController = RMDateSelectionViewController(style: RMActionControllerStyle.White)
            
            return false
        }
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) {
            if let textField = cell.contentView.viewWithTag(1) as? UITextField {
                textField.delegate = self
            }
        }
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) {
            if let textField = cell.contentView.viewWithTag(2) as? UITextField {
                textField.delegate = self
            }
        }
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) {
            if let textField = cell.contentView.viewWithTag(3) as? UITextField {
                textField.delegate = self
            }
        }
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 0)) {
            if let textField = cell.contentView.viewWithTag(4) as? UITextField {
                textField.delegate = self
            }
        }
    }
    
}
