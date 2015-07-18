//
//  PreviewCaptureViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 13/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit
import MBProgressHUD
import FLAnimatedImage
import Parse
import jot

class PreviewCaptureViewController: UIViewController {

    var event: PFObject?
    var capturedMedia: Media💿!
    var currentEvent: PFObject?
    var jotController: JotViewController!
    @IBOutlet var imageView: FLAnimatedImageView!
    @IBOutlet var buttonCurrentMoment: UIButton!
    @IBOutlet var validateButton: UIButton!
    //@IBOutlet var drawView: DrawView!
    
    @IBAction func addTextViewMedia(sender: AnyObject) {
//        if mediaTextView.alpha == 0 {
//            mediaTextView.text = "Ajoute ton text ici."
//            mediaTextView.alpha = 1
//        }
//        else {
//            mediaTextView.alpha = 0
//        }
    }
    
    @IBAction func cancelPreview(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sharePreviewContent(sender: AnyObject) {
        var shareMedia: AnyObject!
        switch capturedMedia! {
        case Media💿.Photo(let image): shareMedia = image
        case Media💿.Gif(let data): shareMedia = data
        default: break
        }
        
        let shareController = UIActivityViewController(activityItems: [shareMedia], applicationActivities: nil)
        navigationController?.presentViewController(shareController, animated: true, completion: nil)
    }
    
    @IBAction func validatePreview(sender: AnyObject) {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Votre Wizz est en cours d'upload."
        
        var file: PFFile!
        switch capturedMedia! {
        case Media💿.Photo(let image):
            let img = jotController.drawOnImage(image)
            file = PFFile(data: UIImageJPEGRepresentation(img, 0.5))
        case Media💿.Gif(let data): file = PFFile(data: data)
        }
        
//        if mediaTextView.alpha > 0 {
//            let imageSize = PhotoHelper.aspectScaledImageSizeForImageView(imageView, image: imageView.image!)
//            
//            let font:UIFont = UIFont.boldSystemFontOfSize(60)
//            let color: UIColor = UIColor.whiteColor()
//            let paragrapheStyle = NSMutableParagraphStyle()
//            paragrapheStyle.alignment = NSTextAlignment.Center
//            let attributeDict:NSDictionary = [NSFontAttributeName:font,
//                NSForegroundColorAttributeName:color,
//                NSParagraphStyleAttributeName:paragrapheStyle]
//            
//            let text = NSString(string: mediaTextView.text)
//            
//            UIGraphicsBeginImageContextWithOptions(imageView.image!.size, false, 0)
//            imageView.image!.drawInRect(CGRectMake(0, 0, imageView.image!.size.width, imageView.image!.size.height))
//            
//            let positionX = imageView.image!.size.width / imageSize.width * mediaTextView.frame.origin.x
//            let positionY = imageView.image!.size.height / imageSize.height * (mediaTextView.frame.origin.y - (UIScreen.mainScreen().bounds.size.height - imageSize.height) / 2)
//            
//            println("position : \(mediaTextView.frame.origin.x) \(mediaTextView.frame.origin.x)")
//            
//            text.drawInRect(CGRectMake(0, positionY, imageView.image!.size.width, 500), withAttributes: attributeDict as [NSObject : AnyObject])
//            
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            file = PFFile(data: UIImageJPEGRepresentation(image, 0.5))
//            imageView.image = image
//        }
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geo: PFGeoPoint?, _) -> Void in
            if let geo = geo {
                file.saveInBackgroundWithBlock { (_, err: NSError?) -> Void in
                    
                    if err != nil {
                        Alert.error("Vous devez selectionnez ou créer un moment avant de publier.")
                        return
                    }
                    
                    let params = NSMutableDictionary()
                    if let event = self.currentEvent {
                        params.setValue(event.objectId!, forKey: "eventId")
                    }
                    else {
                        Alert.error("Vous devez selectionnez ou créer un moment avant de publier.")
                    }
                    
                    params.setValue(PFUser.currentUser()!.objectId!, forKey: "userId")
                    params.setValue(file, forKey: "file")
                    params.setValue(geo, forKey: "location")
                    
                    println("\(params)")
                    
                    PFCloud.callFunctionInBackground("MediaAdd", withParameters: params as [NSObject : AnyObject]) { (_, error: NSError?) -> Void in
                        hud.hide(true)
                        if let error = error {
                            println("error : \(error)")
                            Alert.error("Erreur lors de l'uplaod de votre Wizz.")
                        }
                        else {
                            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                                if let event = self.event {
                                    NSNotificationCenter.defaultCenter().postNotificationName("dismissCameraController", object: nil)
                                }
                            })
                        }
                    }
                }
            }
            else {
                Alert.error("Erreur, lors de la récupération de votre géolocalisation.")
                return
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        addChildViewController(jotController)
        view.addSubview(jotController.view)
        jotController.didMoveToParentViewController(self)
        jotController.view.frame = view.bounds
        jotController.state = JotViewState.Text
        
        view.bringSubviewToFront(validateButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mediaTextView.alpha = 0
        navigationController?.interactivePopGestureRecognizer.delegate = nil

        if let event = event {
            if let title = event["title"] as? String {
                buttonCurrentMoment.setTitle(title, forState: UIControlState.Normal)
            }
            currentEvent = event
        }
        else {
            PFCloud.callFunctionInBackground("EventGetLast", withParameters: nil) { (result: AnyObject?, err: NSError?) -> Void in
                println("error : \(err)")
                if let result = result as? PFObject {
                    self.currentEvent = result
                    if let title = result["title"] as? String {
                        self.buttonCurrentMoment.setTitle(title, forState: UIControlState.Normal)
                    }
                    println("result last event : \(result)")
                }
            }
        }
        
        switch capturedMedia! {
        case Media💿.Photo(let image):
            imageView.image = image
        case Media💿.Gif(let data):
            imageView.animatedImage = FLAnimatedImage(GIFData: data)
        default: break
        }
        
        let querry = PFQuery(className: "Event")
        querry
        
        jotController = JotViewController()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "eventSelectionSegue" {
            if let controller = (segue.destinationViewController as! UINavigationController).viewControllers.first as? WizzListViewController {
                controller.completionSelection = {(event: PFObject) -> Void in
                    self.currentEvent = event
                    self.buttonCurrentMoment.setTitle(event["title"] as? String, forState: UIControlState.Normal)
                }
            }
        }
    }
}
