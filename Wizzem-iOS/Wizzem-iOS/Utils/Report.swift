//
//  Report.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 09/09/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

//@"{\"key\": \"abcdefg123456\", \"raw_message\": \"From: me@mydomain.com\nTo: me@myotherdomain.com\nSubject: Some Subject\n\nSome content.}"

class Report: NSObject {
   
    class func send(message: String) {
        
        let param = NSMutableDictionary()
        param.setObject("bHf2D1HTpK672tdYOJmh5g", forKey: "key")
        
        let rawMessage = NSMutableDictionary()
        rawMessage.setObject("[Wizzem] new report", forKey: "subject")
        rawMessage.setObject("salut test", forKey: "text")
        rawMessage.setObject("remirobert33530@gmail.com", forKey: "from_email")
        rawMessage.setObject("report content wizzem", forKey: "from_name")
        
        let toDest = NSMutableDictionary()
        toDest.setObject("remirobert33530@gmail.com", forKey: "email")
        toDest.setObject("report", forKey: "name")
        toDest.setObject("to", forKey: "type")
        
        param.setObject(rawMessage, forKey: "message")
        param.setObject(toDest, forKey: "to")
        
        let manager = AFHTTPRequestOperationManager()
        manager.GET("https://mandrillapp.com/api/1.0/messages/send.json", parameters: param, success: { (response: AFHTTPRequestOperation, result: AnyObject?) -> Void in
            
            println("response : \(response)")
            println("result : \(result)")
            
            println("send success")
            
            }) { (_, err: NSError) -> Void in
            
                println("err : \(err)")
        }
    }
}
