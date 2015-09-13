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
    var titleEventContent: String!
    @IBOutlet var textView: UITextView!
    @IBOutlet var titleEvent: UILabel!
    
    @IBAction func dismissDetailDescription(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.text = content
        self.textView.editable = false
        self.titleEvent.text = self.titleEventContent
    }
}
