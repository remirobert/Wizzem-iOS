//
//  DetailCoverViewController.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 15/09/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class DetailCoverViewController: UIViewController {

    @IBOutlet var coverImage: UIImageView!
    var imageCover: UIImage!
    
    @IBAction func dismissDetail(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coverImage.image = imageCover
    }

}
