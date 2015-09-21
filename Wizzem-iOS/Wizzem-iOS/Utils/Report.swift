//
//  Report.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 09/09/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

/*
"key": "bHf2D1HTpK672tdYOJmh5g",
"message": {
    "text": "Example text content",
    "subject": "example subject",
    "from_email": "message.from_email@example.com",
    "from_name": "remirobert",
    "to": [
    {
    "email": "remirobert33530@gmail.com",
    "name": "remirobert",
    "type": "to"
    }
    ]
}
*/

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
        toDest.setObject("remirobert", forKey: "name")
        toDest.setObject("to", forKey: "type")
        rawMessage.setObject([toDest], forKey: "to")
        
        param.setObject(rawMessage, forKey: "message")
        
        let manager = AFHTTPRequestOperationManager()
        manager.GET("https://mandrillapp.com/api/1.0/messages/send.json", parameters: param, success: { (response: AFHTTPRequestOperation, result: AnyObject?) -> Void in
            
            print("response : \(response)")
            print("result : \(result)")
            
            print("send success")
            
            }) { (_, err: NSError) -> Void in
            
                print("err : \(err)")
        }
    }
}
