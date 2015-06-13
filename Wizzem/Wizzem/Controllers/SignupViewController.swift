//
//  SignupViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 11/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse
import SwiftMoment
import MBProgressHUD

class SignupViewController: UIViewController {

    var firstNameText: String?
    var lastNameText: String?
    var emailText: String?
    var passwordText: String?
    var date: String?
    var sex: Int?
    
    var newUser: PFUser?

    @IBAction func backController(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        if let firstNameText = firstNameText,
            let lastNameText = lastNameText,
            let emailText = emailText,
            let passwordText = passwordText,
            let date = date,
            let sex = sex,
            let newUser = newUser {
                
                let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
                hud.labelText = "Creation du compte en cours"
                
                newUser.setValue("\(firstNameText)\(lastNameText)", forKey: "true_username")

                ParseAuth.signup(user: newUser, completionBlock: { (result) -> () in
                    hud.hide(true)
                    switch result {
                    case Result.👍: break
                    case Result.👎(_, let error):
                        Alert.error("\(error))")
                    }
                })
        }
        else {
            let alert = UIAlertView(title: "Erreur formulaire d'inscription non complet.",
                message: "Remplissez tous les champs pour pouvoir créer votre compte.", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newUser = PFUser()
        self.sex = 0
        self.newUser?.setValue("F", forKey: "gender")
        
        navigationController?.interactivePopGestureRecognizer.delegate = nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_SIGNUP_CONTAINER {
            if let signupController = segue.destinationViewController as? SignupTableViewController {
                signupController.completionUpdateFirstName = {(content: String) -> Void in
                    self.firstNameText = content
                    self.newUser?.setValue(content, forKey: "first_name")
                }
                signupController.completionUpdateLastName = {(content: String) -> Void in
                    self.lastNameText = content
                    self.newUser?.setValue(content, forKey: "last_name")
                }
                signupController.completionUpdateEmail = {(content: String) -> Void in
                    self.emailText = content
                    self.newUser?.setValue(content, forKey: "username")
                }
                signupController.completionUpdatePassword = {(content: String) -> Void in
                    self.passwordText = content
                    self.newUser?.password = content
                }
                signupController.completionUpdateDate = {(date: String) -> Void in
                    self.date = date
                    self.newUser?.setValue(date, forKey: "birthdate")
                }
                signupController.completionUpdateSex = {(sex: Int) -> Void in
                    self.sex = sex
                    self.newUser?.setValue((sex == 0) ? "F" : "H", forKey: "gender")
                }
            }
        }
    }

}
