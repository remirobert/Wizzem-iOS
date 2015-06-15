//
//  Alert.swift
//  Wizzem
//
//  Created by Remi Robert on 13/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class Alert: NSObject, UIAlertViewDelegate {
  
    var completionSuccess: (() -> Void)!
    var completionCancel: (() -> Void)!
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            if let completionSuccess = completionSuccess {
                completionSuccess()
            }
        }
        else {
            if let completionCancel = completionCancel {
                completionCancel()
            }
        }
    }
    
    func alertViewCancel(alertView: UIAlertView) {
        if let completionCancel = completionCancel {
            completionCancel()
        }
    }
    
    func initAlertViewWithBlock(message: String, completionSuccess:(() -> Void), completionCancel:(() -> Void)) {
        let alert =  UIAlertView(title: nil, message: message, delegate: self, cancelButtonTitle: "Annuler")
        
        alert.addButtonWithTitle("Ok")
        alert.show()
        
        self.completionSuccess = completionSuccess
        self.completionCancel = completionCancel
    }
    
    class func withBlock(message: String, completionSuccess:(() -> Void), completionCancel:(() -> Void)) {
       
        var alert = Alert()
        alert.initAlertViewWithBlock(message, completionSuccess: completionSuccess, completionCancel: completionCancel)
    }
    
    class func error(message: String) {
        let alert = UIAlertView(title: nil, message: message, delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
}
