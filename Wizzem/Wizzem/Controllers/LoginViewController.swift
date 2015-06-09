//
//  LoginViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 09/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
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
    
    @IBAction func createAccount(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
