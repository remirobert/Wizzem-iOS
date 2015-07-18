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
    
    func createWizz() {
        self.performSegueWithIdentifier("createNewWizzSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.frame.size = CGSizeMake(30, 30)
        button.frame.origin = CGPointMake(CGRectGetWidth(UIScreen.mainScreen().bounds) / 2 - 25, CGRectGetHeight(UIScreen.mainScreen().bounds) - 30)
        button.backgroundColor = UIColor.redColor()
        button.addTarget(self, action: "createWizz", forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(button)
    }

}
