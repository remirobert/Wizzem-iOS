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
        print("detect invitation link")
        let alertController = UIAlertController(title: "Vous avez reçu une invitation", message: "De l'event : \(eventId)", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancel = UIAlertAction(title: "Refuser", style: UIAlertActionStyle.Default, handler: nil)
        let joinAction = UIAlertAction(title: "Rejoindre", style: UIAlertActionStyle.Default, handler: { (_) -> Void in

            let querry = PFQuery(className: "Event")
            querry.whereKey("objectId", equalTo: eventId)
            querry.findObjectsInBackgroundWithBlock({ (results: [AnyObject]?, _) -> Void in
                if let results = results {
                    let event = results.first as! PFObject
                    self.checkJoinUser(eventId, currentEvent: event)
                }
                else {
                    Alert.error("Moment non trouvé. Veuillez renouveller votre lien de partage.")
                }
            })
        })
        alertController.addAction(cancel)
        alertController.addAction(joinAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func clickAction(sender: UIButton) {
        if sender.tag == 1 {
            self.selectedIndex = 0
            self.buttonProfile.setImage(UIImage(named: "Profile"), forState: UIControlState.Normal)
            self.buttonExplore.setImage(UIImage(named: "ExploreOn"), forState: UIControlState.Normal)
        }
        else {
            self.selectedIndex = 1
            self.buttonProfile.setImage(UIImage(named: "ProfileOn"), forState: UIControlState.Normal)
            self.buttonExplore.setImage(UIImage(named: "Explore"), forState: UIControlState.Normal)
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if self.selectedIndex == 0 {
            self.buttonProfile.setImage(UIImage(named: "Profile"), forState: UIControlState.Normal)
            self.buttonExplore.setImage(UIImage(named: "ExploreOn"), forState: UIControlState.Normal)
        }
        else {
            self.buttonProfile.setImage(UIImage(named: "ProfileOn"), forState: UIControlState.Normal)
            self.buttonExplore.setImage(UIImage(named: "Explore"), forState: UIControlState.Normal)
        }
    }
    
    func displayProfileController() {
        if let _ = self.viewControllers?.last {
            self.selectedIndex = 0
            self.buttonProfile.setImage(UIImage(named: "Profile"), forState: UIControlState.Normal)
            self.buttonExplore.setImage(UIImage(named: "ExploreOn"), forState: UIControlState.Normal)
        }
    }
    
    func displayFeedController() {
        if let _ = self.viewControllers?.first {
            self.selectedIndex = 1
            self.buttonProfile.setImage(UIImage(named: "ProfileOn"), forState: UIControlState.Normal)
            self.buttonExplore.setImage(UIImage(named: "Explore"), forState: UIControlState.Normal)
        }
    }
    
    func createWizz() {
        self.performSegueWithIdentifier("addMediaSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayProfileController", name: "displayProfileController", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayFeedController", name: "displayFeedController", object: nil)
        
        let button = UIButton(type: UIButtonType.Custom)
        button.frame.origin = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2 - 50, UIScreen.mainScreen().bounds.size.height - 50 - self.tabBar.frame.size.height / 2)
        button.backgroundColor = UIColor.clearColor()
        button.setImage(UIImage(named: "Capture"), forState: UIControlState.Normal)
        //button.tintColor = UIColor(red:0.99, green:0.37, blue:0.4, alpha:1)
        button.autoresizingMask = [UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleTopMargin]
        button.addTarget(self, action: "createWizz", forControlEvents: UIControlEvents.TouchUpInside)
        button.frame.size = CGSizeMake(50, 50)
        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        button.center.x = self.view.center.x
        
        
        buttonExplore = UIButton(type: UIButtonType.Custom)
        buttonExplore.frame.size = CGSizeMake(UIScreen.mainScreen().bounds.size.width / 2 + 50, 30)
        buttonExplore.frame.origin = CGPointMake(-50, UIScreen.mainScreen().bounds.size.height - 44.5)
        buttonExplore.backgroundColor = UIColor.clearColor()
        buttonExplore.setImage(UIImage(named: "ExploreOn"), forState: UIControlState.Normal)
        buttonExplore.autoresizingMask = [UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleTopMargin]
        buttonExplore.tag = 1
        buttonExplore.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonExplore.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        buttonProfile = UIButton(type: UIButtonType.Custom)
        buttonProfile.frame.size = CGSizeMake(UIScreen.mainScreen().bounds.size.width / 2 + 50, 30)
        buttonProfile.frame.origin = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height - 44.5)
        buttonProfile.backgroundColor = UIColor.clearColor()
        buttonProfile.setImage(UIImage(named: "Profile"), forState: UIControlState.Normal)
        buttonProfile.autoresizingMask = [UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleTopMargin]
        buttonProfile.tag = 2
        buttonProfile.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonProfile.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        
        let heightDifference = 25 - self.tabBar.frame.size.height;
        
        if heightDifference < 0 {
            button.center = self.tabBar.center;
        }
        else {
            var center = self.tabBar.center;
            center.y = center.y - heightDifference/2.0;
            button.center = center;
        }
        
        button.center.y = buttonProfile.center.y
        
        self.view.addSubview(buttonExplore)
        self.view.addSubview(buttonProfile)
        self.view.addSubview(button)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addMediaSegue" {
            let controller = segue.destinationViewController 
            
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

extension MainTabBarViewController {
    func checkJoinUser(eventId: String, currentEvent: PFObject) {
        let querry = PFQuery(className: "Participant")
        querry.whereKey("eventId", equalTo: currentEvent)
        querry.whereKey("userId", equalTo: PFUser.currentUser()!)
        
        querry.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, _) -> Void in
            if results == nil || results?.count == 0 {
                let newParticipant = PFObject(className: "Participant")
                newParticipant["eventId"] = currentEvent
                newParticipant["userId"] = PFUser.currentUser()!
                newParticipant["approval"] = true
                newParticipant["invited"] = false
                newParticipant["status"] = "accepted"
                newParticipant.saveInBackgroundWithBlock({ (success: Bool, _) -> Void in
                    if success {
                        print("sucess add")
                        
                        if let numberParticipant = currentEvent["nbParticipant"] as? Int {
                            currentEvent["nbParticipant"] = numberParticipant + 1
                            currentEvent.saveInBackgroundWithBlock({ (_, _) -> Void in})
                        }
                        
                        let controller = InstanceController.fromStoryboard("detailMomentController")
                        (controller as! DetailMediaViewController).currentEvent = currentEvent
                        self.presentViewController(controller!, animated: true, completion: nil)
                    }
                    else {
                        Alert.error("Impossible de rejoindre ce moment.")
                    }
                })
            }
            else {
                Alert.error("Vous participez déjà à ce moment.")
            }
        }
    }
}
