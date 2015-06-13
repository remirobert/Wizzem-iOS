//
//  Alert.swift
//  Wizzem
//
//  Created by Remi Robert on 13/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class Alert {
  
    class func error(message: String) {
        let alert = UIAlertView(title: nil, message: message, delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
}
