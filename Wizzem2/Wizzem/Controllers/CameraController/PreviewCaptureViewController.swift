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
    @IBOutlet var imageView: FLAnimatedImageView!
    @IBOutlet var buttonCurrentMoment: UIButton!
    @IBOutlet var validateButton: UIButton!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var selectMomentButton: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet var drawView: TextDrawer!
    
    @IBAction func addTextViewMedia(sender: AnyObject) {
    }
    
    @IBAction func cancelPreview(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sharePreviewContent(sender: AnyObject) {
        var shareMedia: AnyObject!
        switch capturedMedia! {
        case Media💿.Photo(let image): shareMedia = image
        case Media💿.Gif(let data, _): shareMedia = data
        default: break
        }
        
        let shareController = UIActivityViewController(activityItems: [shareMedia], applicationActivities: nil)
        navigationController?.presentViewController(shareController, animated: true, completion: nil)
    }
    
    func addTextOnGif(images: [UIImage]) -> [UIImage] {
        var imagesText = Array<UIImage>()
        for img in images {
            self.imageView.image = img
            if let image = drawView.renderTextOnView(self.imageView) {
                imagesText.append(image)
            }
        }
        return imagesText
    }
    
    func addMedia(file: PFFile, hud: MBProgressHUD, type: String) {
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
                    params.setValue(type, forKey: "type")
                    
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
    
    @IBAction func validatePreview(sender: AnyObject) {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Votre Wizz est en cours d'upload."
        
        var imagesGif: [UIImage]?
        var file: PFFile!
        switch capturedMedia! {
        case Media💿.Photo(let image):
            let img = drawView.renderTextOnView(self.imageView)
            file = PFFile(data: UIImageJPEGRepresentation(img, 0.5))
        case Media💿.Gif(let data, let frames): imagesGif = addTextOnGif(frames)
        }
        
        if let images = imagesGif {
            GifMaker().makeAnimatedGif(images, blockCompletion: { (dataGif: NSData!) -> Void in
                file = PFFile(data: dataGif)
                self.addMedia(file, hud: hud, type: "gif")

            })
        }
        else {
            addMedia(file, hud: hud, type: "photo")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        view.bringSubviewToFront(validateButton)
        view.bringSubviewToFront(closeButton)
        view.bringSubviewToFront(selectMomentButton)
        view.bringSubviewToFront(containerView)
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
        case Media💿.Gif(let data, _):
            imageView.animatedImage = FLAnimatedImage(GIFData: data)
        default: break
        }
        
        let querry = PFQuery(className: "Event")
        querry
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
