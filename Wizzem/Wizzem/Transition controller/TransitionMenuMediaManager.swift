//
//  TransitionShopManager.swift
//  fashionSmiley3
//
//  Created by Remi Robert on 04/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class TransitionMenuMediaManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
   
    var presenting: Bool!
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        let screens : (from:UIViewController, to:UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
        println("passed here")
//        var offScreenRight = CGAffineTransformMakeTranslation(0, container.frame.height)
//        var offScreenLeft = CGAffineTransformMakeTranslation(0, 0)
//        if (self.presenting == false) {
//            offScreenRight = CGAffineTransformMakeTranslation(0, 0)
//            offScreenLeft = CGAffineTransformMakeTranslation(0, -container.frame.height)
//        }
//        screens.to.view.transform = offScreenRight
        

//        if (self.presenting == true) {
//            screens.to.view.frame.origin.y = UIScreen.mainScreen().bounds.size.height
//        }
//        else {
//            screens.from.view.frame.origin.y = 0
//        }
        
        
        if (self.presenting == true) {
            screens.to.view.frame.origin.y = UIScreen.mainScreen().bounds.size.height
            screens.to.view.alpha = 0
            container.addSubview(screens.from.view)
            container.addSubview(screens.to.view)
        }
        else {
            container.addSubview(screens.to.view)
            container.addSubview(screens.from.view)
            //screens.from.view.alpha = 1
        }
        
        var duration = self.transitionDuration(transitionContext)
        if (self.presenting == false) {
            duration = 0
        }

        println("to : \(screens.to) from : \(screens.from) => presenting result : \(self.presenting)")
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.AllowUserInteraction, animations: {

            if (self.presenting == true) {
                screens.to.view.alpha = 1
                screens.to.view.frame.origin = CGPointMake(0, UIScreen.mainScreen().bounds.size.height - 300)
                screens.from.view.frame.origin = CGPointMake(0, -300)
                screens.from.view.alpha = 0.5
//                screens.to.view.alpha = 1
//                screens.from.view.alpha = 1
                //self.offScreenAnimation(screens.to)
            }
            else {
                screens.from.view.alpha = 0
                screens.to.view.frame.origin.y = 0
                screens.from.view.frame.origin.y = UIScreen.mainScreen().bounds.size.height
                screens.to.view.alpha = 1
//                screens.from.view.alpha = 0
//                screens.to.view.alpha = 1
                //self.onScreenAnimation(screens.from)
            }
            
//            screens.from.view.transform = offScreenLeft
//            screens.to.view.transform = CGAffineTransformIdentity
            
            }, completion: { finished in
                

                UIApplication.sharedApplication().keyWindow?.addSubview(screens.to.view)
                transitionContext.completeTransition(true)
        })
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
}
