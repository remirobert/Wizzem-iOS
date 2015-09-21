//
//  DetailProfileViewController.swift
//  
//
//  Created by Remi Robert on 02/08/15.
//
//

import UIKit

class DetailProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var profilePicture: FLAnimatedImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var settingButton: UIButton!
    var user: PFObject!
    
    @IBAction func dismissController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func facebookProfile(sender: AnyObject) {
        if let facebookId = user["facebookId"] as? String {
            UIApplication.sharedApplication().openURL(NSURL(string: "fb://profile/\(facebookId)")!)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let type = (info[UIImagePickerControllerReferenceURL] as! NSURL).absoluteString.componentsSeparatedByString("=").last
        let urlMedia = info[UIImagePickerControllerReferenceURL] as! NSURL
        
        var dataMedia: NSData!
        var mediaType: String!
        
        print("type : \(type)")
        
        if type == "GIF" {
            let librairi: ALAssetsLibrary = ALAssetsLibrary()
            librairi.assetForURL(urlMedia, resultBlock: { (asset: ALAsset!) -> Void in
                
                dataMedia = PhotoHelper.convertAssetToData(asset)
                mediaType = "GIF"
                self.updateProfile(dataMedia, type: mediaType)
                
                }) { (_) -> Void in return }
        }
        else {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            dataMedia = UIImageJPEGRepresentation(image, 0.1)
            mediaType = "JPG"
            updateProfile(dataMedia, type: mediaType)
        }
    }

    func changePictureProfile() {
        let alertController = UIAlertController(title: "Changer ça photo de profile.", message: "GIF ou photos.", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let changeAction = UIAlertAction(title: "Choisir depuis la gallery", style: UIAlertActionStyle.Default) { (_) -> Void in
            let controller = UIImagePickerController()
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            controller.delegate = self
            self.presentViewController(controller, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(changeAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func displayPictureImage() {
        if let userFile = user["picture"] as? PFFile {
            userFile.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                if let data = data {
                    if let dataType = self.user["typePicture"] as? String where dataType == "GIF" {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let animatedImage = FLAnimatedImage(animatedGIFData: data)
                            print("aimated image : \(animatedImage)")
                            self.profilePicture.animatedImage = animatedImage
                        })
                    }
                    else {
                        self.profilePicture.image = UIImage(data: data)
                    }
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.usernameLabel.text = nil
        
        settingButton.alpha = 0
        if user.objectId == PFUser.currentUser()?.objectId {
            settingButton.alpha = 1
            settingButton.addTarget(self, action: "changePictureProfile", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        self.user.fetchInBackgroundWithBlock { (user: PFObject?, _) -> Void in
            if let user = user {
                self.displayPictureImage()
                self.usernameLabel.text = user["true_username"] as? String
            }
        }
    }
}

extension DetailProfileViewController {
    func updateProfile(imageData: NSData, type: String) {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let fileImage = PFFile(data: imageData)
        fileImage.saveInBackgroundWithBlock({ (success: Bool, _) -> Void in
            if success {
                self.user["typePicture"] = type
                self.user["picture"] = fileImage
                self.user.saveInBackgroundWithBlock({ (success: Bool, _) -> Void in
                    if success {
                        hud.hide(true)
                        self.displayPictureImage()
                    }
                    else {
                        hud.hide(true)
                        Alert.error("Impossible de changer votre image de profile")
                    }
                })
            }
            else {
                hud.hide(true)
                Alert.error("Impossible de changer votre image de profile")
            }
        })
    }
}
