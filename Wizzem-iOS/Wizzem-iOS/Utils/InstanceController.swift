//
//  InstanceController.swift
//  Wizzem
//
//  Created by Remi Robert on 14/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class InstanceController {
   
    class func fromStoryboard(identifier: String) -> UIViewController? {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = mainStoryboard.instantiateViewControllerWithIdentifier(identifier) as? UIViewController {
            return controller
        }
        return nil
    }
    
}
