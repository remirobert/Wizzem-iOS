//
//  ImageDownloader.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 16/09/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class ImageDownloader: NSObject {
    
    class func download(url: String, blockCompletion:((image: UIImage?) -> Void)) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let manager = AFURLSessionManager(sessionConfiguration: configuration)
        
        if let url = NSURL(string: url) {
            let request = NSURLRequest(URL: url)
            
            let downloadTask = manager.downloadTaskWithRequest(request, progress: nil, destination: { (url: NSURL, response: NSURLResponse) -> NSURL in
                if let documentsPath = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory,
                    inDomains: NSSearchPathDomainMask.UserDomainMask).first as? NSURL,
                    let suggestFile = response.suggestedFilename {
                        return documentsPath.URLByAppendingPathComponent(suggestFile)
                }
                else {
                    return url
                }
                }, completionHandler: { (_, url: NSURL?, err: NSError) -> Void in
                    
                    if let url = url, let dataImage = NSData(contentsOfURL: url) {
                        let image = UIImage(data: dataImage)
                        blockCompletion(image: image)
                    }
                    else {
                        blockCompletion(image: nil)
                    }
            })
        }
    }
}
