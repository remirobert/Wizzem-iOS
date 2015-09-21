//
//  SettingsViewController.swift
//  
//
//  Created by Remi Robert on 23/07/15.
//
//

import UIKit

class SettingsViewController: UIViewController {

    @IBAction func logout(sender: AnyObject) {
        
        let hud = MBProgressHUD(forView: self.view)
        hud.labelText = "Deconnection"
        
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
            hud.hide(true)
            if error != nil {
                Alert.error("Error lors de la déconnection")
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("loginSignupController") 
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func shareApp(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Venez découvrir l'Application Wizzem sur l'apple store"], applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
