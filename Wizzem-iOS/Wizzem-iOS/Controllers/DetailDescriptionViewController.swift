//
//  DetailDescriptionViewController.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 31/08/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class DetailDescriptionViewController: UIViewController {

    var content: String!
    @IBOutlet var textView: UITextView!
    
    @IBAction func dismissDetailDescription(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.text = content
    }
}
