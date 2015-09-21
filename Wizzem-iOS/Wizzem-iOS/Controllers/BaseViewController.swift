//
//  BaseViewController.swift
//  
//
//  Created by Remi Robert on 21/06/15.
//
//

import UIKit

protocol PageController {
    var page: Int {get set}
}

class BaseViewController: UIViewController, UIPageViewControllerDataSource {

    var pageViewController: UIPageViewController!
    var controllers: [AnyObject]!
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var currentIndexPage = (viewController as! PageController).page
        currentIndexPage -= 1
        
        if currentIndexPage >= 0 {
            return controllers[currentIndexPage] as? UIViewController
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var currentIndexPage = (viewController as! PageController).page
        currentIndexPage += 1
        
        if currentIndexPage < controllers.count {
            return controllers[currentIndexPage] as? UIViewController
        }
        return nil
    }
    
//    func swipeControllerCamera() {
//        pageViewController.setViewControllers([controllers[1]], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
//    }
//
//    func swipeControllerFeed() {
//        pageViewController.setViewControllers([controllers[0]], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "swipeControllerCamera", name: "swipControllerCamera", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "swipeControllerFeed", name: "swipControllerFeed", object: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controllers = [storyboard.instantiateViewControllerWithIdentifier("mainNavigationController"),
        storyboard.instantiateViewControllerWithIdentifier("mediaCaptureController")]
        
        pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        
        pageViewController.setViewControllers([controllers[0] as! UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        pageViewController.dataSource = self
        
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
    }
    
}
