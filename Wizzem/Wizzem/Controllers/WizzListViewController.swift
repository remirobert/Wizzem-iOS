//
//  WizzListViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 14/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse

class WizzListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    @IBAction func dismissController(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
