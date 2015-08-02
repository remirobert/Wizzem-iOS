//
//  DetailProfileViewController.swift
//  
//
//  Created by Remi Robert on 02/08/15.
//
//

import UIKit

class DetailProfileViewController: UIViewController {

    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var numberMomentLabel: UILabel!
    @IBOutlet var numberWizzLabel: UILabel!
    var user: PFObject!
    
    @IBAction func dismissController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func facebookProfile(sender: AnyObject) {
    }
    
    @IBAction func inviteMoment(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userFile = self.user["picture"] as? PFFile {
            userFile.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                if let data = data {
                    self.profilePicture.image = UIImage(data: data)
                }
            })
        }

    }
}
