//
//  LoginViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 09/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit
import WaitBlock

class LoginViewController: UIViewController {

    var emailText: String?
    var passwordText: String?
    
    @IBAction func facebookLogin(sender: AnyObject) {
        FacebookAuth.login { (result) -> () in
            switch result {
            case .👍: println("auth okay")
            case .👎(_, let error):
                println("error auth : \(error))")
            }
        }
    }
    
    @IBAction func connection(sender: AnyObject) {
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_LOGIN_CONTAINER {
            if let loginController = segue.destinationViewController as? LoginTableViewController {
                loginController.completionUpdateEmail = {(content: String) -> Void in
                    self.emailText = content
                    println("email content : \(self.emailText!)")
                }
                loginController.completionUpdatePassword = {(content: String) -> Void in
                    self.passwordText = content
                    println("password content : \(self.passwordText!)")
                }
            }
        }
    }
}
