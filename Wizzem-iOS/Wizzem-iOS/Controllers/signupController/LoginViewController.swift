//
//  LoginViewController.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 12/08/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageIndicator: UIPageControl!
    @IBOutlet var loginButton: UIButton!
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        self.pageIndicator.currentPage = currentPage
    }
    
    func presentMediaMainController() {
        if let controller = InstanceController.fromStoryboard("mainController") {
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func login(sender: AnyObject) {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Connection en cours"
        
        FacebookAuth.login { (result) -> () in
            hud.hide(true)
            switch result {
            case .👍:
                hud.hide(true)
                self.presentMediaMainController()
            case .👎(_, let error):
                hud.hide(true)
                Alert.error("Error lors de la connection : \(error)")
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let fbSDKLoginButton = FBSDKLoginButton()
//        fbSDKLoginButton.userInteractionEnabled = false
//        self.loginButton.addSubview(fbSDKLoginButton)
//        fbSDKLoginButton.frame = CGRectMake(0, 0, 220, 45)
        
        let page1 = UIImageView(frame: CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds)))
        page1.image = UIImage(named: "page1")
        page1.contentMode = UIViewContentMode.ScaleAspectFit
        
        let page2 = UIImageView(frame: CGRectMake(CGRectGetWidth(UIScreen.mainScreen().bounds), 0, CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds)))
        page2.image = UIImage(named: "page2")
        page2.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.scrollView.addSubview(page1)
        self.scrollView.addSubview(page2)
        
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.delegate = self
        self.scrollView.pagingEnabled = true
        self.scrollView.bounces = false
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds) * 2, CGRectGetHeight(UIScreen.mainScreen().bounds))
    }
}
