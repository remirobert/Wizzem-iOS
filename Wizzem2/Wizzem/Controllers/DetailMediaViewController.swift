//
//  DetailMediaViewController.swift
//  
//
//  Created by Remi Robert on 12/07/15.
//
//

import UIKit
import FLAnimatedImage
import Parse

class DetailMediaViewController: UIViewController {

    var currentEvent: PFObject!
    var currentMedia: PFObject!
    var currentIndex: Int!
    
    @IBOutlet var imageView: FLAnimatedImageView!
    @IBOutlet var titleEvent: UILabel!
    @IBOutlet var currentMediaLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var pseudoLabel: UILabel!
    @IBOutlet var numberLikeLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    
    @IBAction func closeController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        if let mediaFile = currentMedia["file"] as? PFFile {
            mediaFile.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                if let data = data {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        switch self.currentMedia["type"] as! String {
                        case "photo": self.imageView.image = UIImage(data: data)
                        case "gif": self.imageView.animatedImage = FLAnimatedImage(animatedGIFData: data)
                        default: return
                        }
                        self.view.bringSubviewToFront(self.titleEvent)
                        self.view.bringSubviewToFront(self.currentMediaLabel)
                        self.view.bringSubviewToFront(self.profileImageView)
                        self.view.bringSubviewToFront(self.pseudoLabel)
                        self.view.bringSubviewToFront(self.numberLikeLabel)
                        self.view.bringSubviewToFront(self.backButton)
                    })
                }
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController
        
        titleEvent.text = currentEvent["title"] as? String
        numberLikeLabel.text = currentEvent["nbLike"] as? String
        
        let numberMedia = currentEvent["nbMedia"] as? Int
        currentMediaLabel.text = "(\(currentIndex + 1) / \(numberMedia!))"
        
        
        if let user = currentMedia["userId"] as? PFUser {
            pseudoLabel.text = user["true_username"] as? String

            if let filePicture = user["picture"] as? PFFile {
                filePicture.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                    if let data = data {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.profileImageView.image = UIImage(data: data)
                        })
                    }
                })
            }
        }
    }

}
