//
//  SelectCityViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 16/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class SelectCityViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filePath = NSBundle.mainBundle().pathForResource("villes_frances", ofType: "json")

        if let dataFile = NSData(contentsOfFile: filePath!) {
            let json = NSJSONSerialization.JSONObjectWithData(dataFile, options: NSJSONReadingOptions.allZeros, error: nil) as! NSDictionary
            println("json")
        }
        
    }
}
