//
//  MainTabBarViewController.swift
//  
//
//  Created by Remi Robert on 21/06/15.
//
//

import UIKit

class MainTabBarViewController: UITabBarController, PageController {

    var page: Int = 0
    var buttonExplore: UIButton!
    var buttonProfile: UIButton!
    var animator: ZFModalTransitionAnimator!
    
    func displayInvitation(eventId: String) {
        let alertController = UIAlertController(title: "Vous avez reçu une invitation", message: "De l'event : \(eventId)", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancel = UIAlertAction(title: "Refuser", style: UIAlertActionStyle.Default, handler: nil)
        let joinAction = UIAlertAction(title: "Rejoindre", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
            let controller = InstanceController.fromStoryboard("detailMomentController")

            let querry = PFQuery(className: "Event")
            querry.whereKey("objectId", equalTo: eventId)
            querry.findObjectsInBackgroundWithBlock({ (results: [AnyObject]?, _) -> Void in
                if let results = results {
                    let event = results.first as! PFObject
                    (controller as! DetailMediaViewController).currentEvent = event
                    
                    self.presentViewController(controller!, animated: true, completion: nil)
                }
            })
            
        })
        alertController.addAction(cancel)
        alertController.addAction(joinAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func clickAction(sender: UIButton) {
        if sender.tag == 1 {
//            self.buttonExplore.setImage(UIImage(named: "icon-publicRoomOn"), forState: UIControlState.Normal)
//            self.buttonProfile.setImage(UIImage(named: "icon-privateRoomOff"), forState: UIControlState.Normal)
            self.selectedIndex = 0
        }
        else {
//            self.buttonExplore.setImage(UIImage(named: "icon-publicRoomOff"), forState: UIControlState.Normal)
//            self.buttonProfile.setImage(UIImage(named: "icon-privateRoomOn"), forState: UIControlState.Normal)
            self.selectedIndex = 1
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if self.selectedIndex == 0 {
//            self.buttonExplore.setImage(UIImage(named: "icon-publicRoomOn"), forState: UIControlState.Normal)
//            self.buttonProfile.setImage(UIImage(named: "icon-privateRoomOff"), forState: UIControlState.Normal)
        }
        else {
//            self.buttonExplore.setImage(UIImage(named: "icon-publicRoomOff"), forState: UIControlState.Normal)
//            self.buttonProfile.setImage(UIImage(named: "icon-privateRoomOn"), forState: UIControlState.Normal)
        }
    }
    
    func createWizz() {
        self.performSegueWithIdentifier("addMediaSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let button = UIButton()
//        button.frame.size = CGSizeMake(30, 30)
//        button.frame.origin = CGPointMake(CGRectGetWidth(UIScreen.mainScreen().bounds) / 2 - 25, CGRectGetHeight(UIScreen.mainScreen().bounds) - 30)
//        button.backgroundColor = UIColor.redColor()
//        button.addTarget(self, action: "createWizz", forControlEvents: UIControlEvents.TouchUpInside)
//        view.addSubview(button)

        
        let button = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        button.frame.origin = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2 - 40, UIScreen.mainScreen().bounds.size.height - 40)
        button.backgroundColor = UIColor.clearColor()
        button.setImage(UIImage(named: "Capture"), forState: UIControlState.Normal)
        //button.tintColor = UIColor(red:0.99, green:0.37, blue:0.4, alpha:1)
        button.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleTopMargin
        button.addTarget(self, action: "createWizz", forControlEvents: UIControlEvents.TouchUpInside)
        button.frame.size = CGSizeMake(40, 40)
        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        buttonExplore = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonExplore.frame.size = CGSizeMake(UIScreen.mainScreen().bounds.size.width / 2 - 50, 40)
        buttonExplore.frame.origin = CGPointMake(0, UIScreen.mainScreen().bounds.size.height - 44.5)
        buttonExplore.backgroundColor = UIColor.clearColor()
        buttonExplore.setImage(UIImage(named: "Explore"), forState: UIControlState.Normal)
        buttonExplore.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleTopMargin
        buttonExplore.tag = 1
        buttonExplore.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonExplore.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        buttonProfile = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonProfile.frame.size = CGSizeMake(UIScreen.mainScreen().bounds.size.width / 2 - 50, 40)
        buttonProfile.frame.origin = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2 + 50, UIScreen.mainScreen().bounds.size.height - 44.5)
        buttonProfile.backgroundColor = UIColor.clearColor()
        buttonProfile.setImage(UIImage(named: "Profile"), forState: UIControlState.Normal)
        buttonProfile.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleTopMargin
        buttonProfile.tag = 2
        buttonProfile.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonProfile.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        
        let heightDifference = 40 - self.tabBar.frame.size.height;
        
        if heightDifference < 0 {
            button.center = self.tabBar.center;
        }
        else {
            var center = self.tabBar.center;
            center.y = center.y - heightDifference/2.0;
            button.center = center;
        }
        
        self.view.addSubview(buttonExplore)
        self.view.addSubview(buttonProfile)
        self.view.addSubview(button)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addMediaSegue" {
            let controller = segue.destinationViewController as! UIViewController
            
            self.animator = ZFModalTransitionAnimator(modalViewController: controller)
            self.animator.dragable = true
            self.animator.bounces = false
            self.animator.behindViewAlpha = 0.5
            self.animator.behindViewScale = 0.9
            self.animator.transitionDuration = 0.7
            controller.transitioningDelegate = self.animator
        }
    }
    
}
