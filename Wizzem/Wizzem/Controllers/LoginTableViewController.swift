//
//  LoginTableViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 11/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class LoginTableViewController: UITableViewController, UITextFieldDelegate {

    var completionUpdateEmail: ((content: String) -> Void)?
    var completionUpdatePassword: ((content: String) -> Void)?
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string:
        String) -> Bool {
        
            if textField.tag == 1 {
                if let completionUpdateEmail = self.completionUpdateEmail {
                    completionUpdateEmail(content: textField.text)
                }
            }
            else {
                if let completionUpdatePassword = self.completionUpdatePassword {
                    completionUpdatePassword(content: textField.text)
                }
            }
            
            if string == "\n" {
                view.endEditing(true)
                return false
            }
            return true
    }
    
    override func viewDidAppear(animated: Bool) {
        if let emailCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) {
            if let textField = emailCell.contentView.viewWithTag(1) as? UITextField {
                textField.delegate = self
            }
        }
        if let passwordCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) {
            if let textField = passwordCell.contentView.viewWithTag(2) as? UITextField {
                textField.delegate = self
            }
        }
    }

}
