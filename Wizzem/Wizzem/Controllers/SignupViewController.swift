//
//  SignupViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 11/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    var firstNameText: String?
    var lastNameText: String?
    var emailText: String?
    var passwordText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_SIGNUP_CONTAINER {
            if let signupController = segue.destinationViewController as? SignupTableViewController {
                signupController.completionUpdateFirstName = {(content: String) -> Void in
                    self.firstNameText = content
                    println("email content : \(self.firstNameText!)")
                }
                signupController.completionUpdateLastName = {(content: String) -> Void in
                    self.lastNameText = content
                    println("email content : \(self.lastNameText!)")
                }
                signupController.completionUpdateEmail = {(content: String) -> Void in
                    self.emailText = content
                    println("email content : \(self.emailText!)")
                }
                signupController.completionUpdatePassword = {(content: String) -> Void in
                    self.passwordText = content
                    println("password content : \(self.passwordText!)")
                }
            }
        }
    }

}
