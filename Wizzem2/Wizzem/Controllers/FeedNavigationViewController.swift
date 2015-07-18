//
//  FeedNavigationViewController.swift
//  
//
//  Created by Remi Robert on 12/07/15.
//
//

import UIKit

class FeedNavigationViewController: UINavigationController, UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if viewController is DetailMediaViewController {
            navigationBarHidden = true
        }
        else {
            navigationBarHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

}
