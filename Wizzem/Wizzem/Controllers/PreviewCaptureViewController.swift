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
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var valideButton: UIButton!
    
    @IBAction func cancelPreview(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func sharePreview(sender: AnyObject) {
        var shareMedia: AnyObject!
        switch capturedMedia! {
        case Media💿.Photo(let image): shareMedia = image
        case Media💿.Gif(let data): shareMedia = FLAnimatedImage(GIFData: data)
        case Media💿.Text(let content): shareMedia = content
        default: break
        }

        let shareController = UIActivityViewController(activityItems: [shareMedia], applicationActivities: nil)
        navigationController?.presentViewController(shareController, animated: true, completion: nil)
    }
    
    @IBAction func validatePreview(sender: AnyObject) {
    }
    
    override func viewDidAppear(animated: Bool) {
        view.bringSubviewToFront(closeButton)
        view.bringSubviewToFront(shareButton)
        view.bringSubviewToFront(valideButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.contentInset = UIEdgeInsetsMake(24, 0, 10, 0)
        textView.editable = false
        navigationController?.interactivePopGestureRecognizer.delegate = nil

        switch capturedMedia! {
        case Media💿.Photo(let image):
            imageView.image = image
            textView.alpha = 0
        case Media💿.Gif(let data):
            imageView.animatedImage = FLAnimatedImage(GIFData: data)
            textView.alpha = 0
        case Media💿.Text(let content):
            textView.text = content
        default: break
        }
        
    }
}
