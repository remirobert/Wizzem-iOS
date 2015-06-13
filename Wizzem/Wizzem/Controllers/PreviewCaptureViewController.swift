//
//  PreviewCaptureViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 13/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit
import FLAnimatedImage

class PreviewCaptureViewController: UIViewController {

    var capturedMedia: Media💿!
    @IBOutlet var imageView: FLAnimatedImageView!
    
    @IBAction func cancelPreview(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func sharePreview(sender: AnyObject) {
        var shareMedia: AnyObject!
        switch capturedMedia! {
        case Media💿.Photo(let image): shareMedia = image
        case Media💿.Gif(let data): shareMedia = FLAnimatedImage(GIFData: data)
        default: break
        }

        let shareController = UIActivityViewController(activityItems: [shareMedia], applicationActivities: nil)
        navigationController?.presentViewController(shareController, animated: true, completion: nil)
    }
    
    @IBAction func validatePreview(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        switch capturedMedia! {
        case Media💿.Photo(let image): imageView.image = image
        case Media💿.Gif(let data): imageView.animatedImage = FLAnimatedImage(GIFData: data)
        default: break
        }
        
    }
}
