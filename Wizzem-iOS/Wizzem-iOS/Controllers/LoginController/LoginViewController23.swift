//
//  LoginViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 09/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class LoginViewController2: UIViewController {

    var emailText: String?
    var passwordText: String?
    
    func presentMediaMainController() {
        if let controller = InstanceController.fromStoryboard(CONTROLLER_MEDIA_CAPTURE) {
            navigationController?.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func facebookLogin() {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Connection en cours"
        
        FacebookAuth.login { (result) -> () in
            hud.hide(true)
            switch result {
            case .👍:
                hud.hide(true)
                self.presentMediaMainController()
            case .👎(_, let error):
                hud.hide(true)
                Alert.error("Error lors de la connection : \(error)")
            }
        }
    }
    
    @IBAction func connection(sender: AnyObject) {
        if let emailText = emailText, let passwordText = passwordText {
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud.labelText = "Connection en cours"
            
            ParseAuth.login(username: emailText, userPassword: passwordText, completionBlock: { (result) -> () in
                hud.hide(true)
                switch result {
                case Result.👍: self.presentMediaMainController()
                case Result.👎(_, let error):
                    Alert.error("Error lors de la connection : \(error)")
                }
            })
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_LOGIN_CONTAINER {
            if let loginController = segue.destinationViewController as? LoginTableViewController {
                loginController.completionUpdateEmail = {(content: String) -> Void in
                    self.emailText = content
                    print("email content : \(self.emailText!)")
                }
                loginController.completionUpdatePassword = {(content: String) -> Void in
                    self.passwordText = content
                    print("password content : \(self.passwordText!)")
                }
                loginController.completionFacebookAuth = {() -> Void in
                    self.facebookLogin()
                }
            }
        }
    }
}
