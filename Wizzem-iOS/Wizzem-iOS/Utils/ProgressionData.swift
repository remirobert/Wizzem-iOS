//
//  ProgressionData.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 01/09/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class ProgressionData: NSObject {
   
    var numberDatas: Int!
    var numberUploaded: Int!
    
    class var sharedInstance: ProgressionData {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: ProgressionData? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ProgressionData()
            Static.instance?.numberDatas = 0
            Static.instance?.numberUploaded = 0
        }
        return Static.instance!
    }
    
    class func addDataToProgression(number: Int) {
        self.sharedInstance.numberDatas! += number
    }
    
    class func completeDataProgression() {
        self.sharedInstance.numberUploaded! += 1        
        if self.sharedInstance.numberUploaded == self.sharedInstance.numberDatas {
            self.sharedInstance.numberDatas = 0
            self.sharedInstance.numberUploaded = 0
        }
    }
}
