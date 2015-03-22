//
//  TransitionShopManager.swift
//  fashionSmiley3
//
//  Created by Remi Robert on 04/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class TransitionDetailMediaManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
   
    var presenting: Bool!
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        let screens : (from:UIViewController, to:UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
        println("passed here")
        container.addSubview(screens.from.view)
        container.addSubview(screens.to.view)
        
        var offScreenRight = CGAffineTransformMakeTranslation(container.frame.width, 0)
        var offScreenLeft = CGAffineTransformMakeTranslation(-container.frame.width, 0)
        if (self.presenting == false) {
            offScreenRight = CGAffineTransformMakeTranslation(-container.frame.width, 0)
            offScreenLeft = CGAffineTransformMakeTranslation(container.frame.width, 0)
        }
        screens.to.view.transform = offScreenRight
        let duration = self.transitionDuration(transitionContext)

        screens.to.view.alpha = 1
        screens.from.view.alpha = 1
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: nil, animations: {
            
            screens.from.view.transform = offScreenLeft
            screens.to.view.transform = CGAffineTransformIdentity
            screens.from.view.alpha = 0.3
            
            }, completion: { finished in
                
                if (!self.presenting) {
                }

                UIApplication.sharedApplication().keyWindow?.addSubview(screens.to.view)
                transitionContext.completeTransition(true)
        })
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.85
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
