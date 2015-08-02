//
//  ProfileSettingTableViewController.swift
//  
//
//  Created by Remi Robert on 18/07/15.
//
//

import UIKit

class ProfileSettingTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var profilePicture: UIImageView!
    
    @IBAction func closeEditionProfile(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilePicture.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func changePictureProfile(sender: AnyObject) {
        let controller = UIImagePickerController()
        controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        controller.delegate = self
        self.presentViewController(controller, animated: true, completion: nil)
    }

    @IBAction func setModificationProfile(sender: AnyObject) {
        if let photoData = UIImageJPEGRepresentation(profilePicture.image, 0.1) {
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "sauvegarde de vos mofidications"
            
            let file = PFFile(data: photoData)
            file.saveInBackgroundWithBlock({ (_, error: NSError?) -> Void in
                if error != nil {
                    hud.hide(true)
                    Alert.error("Impossible de sauvegarder vos modifications.")
                }
                
                
                PFUser.currentUser()!["first_name"] = self.usernameTextField.text
                PFUser.currentUser()!["last_name"] = self.lastNameTextField.text
                PFUser.currentUser()!["true_username"] = "\(self.usernameTextField.text)\(self.lastNameTextField.text)"
                PFUser.currentUser()!["picture"] = file
                
                PFUser.currentUser()?.saveInBackgroundWithBlock({ (_, error: NSError?) -> Void in
                    hud.hide(true)
                    
                    if error != nil {
                        Alert.error("Impossible de sauvegarder vos modifications.")
                        return
                    }
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            })
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePicture.layer.masksToBounds = true
        usernameTextField.text = PFUser.currentUser()!["first_name"] as? String
        lastNameTextField.text = PFUser.currentUser()!["last_name"] as? String
        if let file = PFUser.currentUser()!["picture"] as? PFFile {
            file.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                if let data = data {
                    self.profilePicture.image = UIImage(data: data)
                }
            })
        }
        
    }
}
