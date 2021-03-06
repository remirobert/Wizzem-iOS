//
//  PreviewCaptureViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 13/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class PreviewCaptureViewController: UIViewController {

    var event: PFObject?
    var capturedMedia: Media💿!
    var currentEvent: PFObject?
    @IBOutlet var imageView: FLAnimatedImageView!
    @IBOutlet var validateButton: UIButton!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet var drawView: TextDrawer!
    @IBOutlet var labelCurrentMoment: UILabel!
    @IBOutlet var textButton: UIButton!
    
    @IBAction func addTextViewMedia(sender: AnyObject) {
        self.drawView.editText()
    }
    
    @IBAction func cancelPreview(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareMedia(sender: AnyObject) {
        var imagesGif: [UIImage]?
        switch capturedMedia! {
        case Media💿.Gif(_, let frames):imagesGif = addTextOnGif(frames)
        default: Void()
        }
        
        if let images = imagesGif {
            GifMaker().makeAnimatedGif(images, blockCompletion: { (dataGif: NSData!) -> Void in
                let controller = UIActivityViewController(activityItems: [dataGif], applicationActivities: nil)
                self.presentViewController(controller, animated: true, completion: nil)
            })
        }
        else {
            let img = drawView.renderTextOnView(self.imageView)
            let controller = UIActivityViewController(activityItems: [UIImagePNGRepresentation(img!)!], applicationActivities: nil)
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func sharePreviewContent(sender: AnyObject) {
        var shareMedia: AnyObject!
        switch capturedMedia! {
        case Media💿.Photo(let image): shareMedia = image
        case Media💿.Gif(let data, _): shareMedia = data
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
    
    @IBAction func validatePreview(sender: AnyObject) {
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Création de votre Media"
        
        var imagesGif: [UIImage]?
        var file: PFFile!
        switch capturedMedia! {
        case Media💿.Photo(_):
            let img = drawView.renderTextOnView(self.imageView)
            file = PFFile(data: UIImageJPEGRepresentation(img!, 0.5)!)
        case Media💿.Gif(_, let frames): imagesGif = addTextOnGif(frames)
        }
        
        if let images = imagesGif {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                GifMaker().makeAnimatedGif(images, blockCompletion: { (dataGif: NSData!) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        hud.hide(true)
                    })
                    file = PFFile(data: dataGif)
                    if let _ = self.event {
                        self.addMedia(file, type: "gif")
                    }
                    else {
                        self.performSegueWithIdentifier("selectMomentSegue", sender: file)
                    }
                })
            })
        }
        else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                hud.hide(true)
            })
            if let _ = event {
                addMedia(file, type: "photo")
            }
            else {
                self.performSegueWithIdentifier("selectMomentSegue", sender: file)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        view.bringSubviewToFront(validateButton)
        view.bringSubviewToFront(closeButton)
        view.bringSubviewToFront(labelCurrentMoment)
        view.bringSubviewToFront(containerView)
        view.bringSubviewToFront(textButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer!.delegate = nil

        self.drawView.textColor = UIColor.whiteColor()
        self.drawView.fontSize = 40
        self.drawView.editTextOnTouch = false
        self.drawView.font = UIFont(name: "ArialRoundedMTBold", size: 40)!
        self.drawView.textSize = 100
        
        if let event = event {
            if let title = event["title"] as? String {
                labelCurrentMoment.text = title
            }
            currentEvent = event
        }
        
        switch capturedMedia! {
        case Media💿.Photo(let image):
            imageView.image = image
        case Media💿.Gif(let data, _):
            imageView.animatedImage = FLAnimatedImage(GIFData: data)
        }
        
        let querry = PFQuery(className: "Event")
        querry
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectMomentSegue" {
            if let controller = (segue.destinationViewController as! UINavigationController).viewControllers.first as? WizzListViewController {
                controller.file = sender as! PFFile
                switch capturedMedia! {
                case .Photo(_): controller.type = "photo"
                case .Gif(_): controller.type = "gif"
                }
            }
        }
    }
}

extension PreviewCaptureViewController {
    func addMedia(file: PFFile, type: String) {
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Upload en cours (0%)"

        file.saveInBackgroundWithBlock({ (_, err: NSError?) -> Void in
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
            params.setValue(self.event!.objectId!, forKey: "eventId")
            params.setValue(file, forKey: "file")
            params.setValue(type, forKey: "type")
            params.setValue(NSDate(), forKey: "creationDate")
            
            PFCloud.callFunctionInBackground("MediaAdd", withParameters: params as [NSObject : AnyObject])
                { (media: AnyObject?, error: NSError?) -> Void in
                hud.hide(true)
                if let error = error {
                    print("error : \(error)")
                    Alert.error("Erreur lors de l'uplaod de votre Wizz.")
                }
                else {
                    let username = (PFUser.currentUser()!["true_username"] as? String)!
                    let nameEvent = (self.event!["title"] as? String)!
                    let message = "\(username) à publier un nouveau média dans \(nameEvent)."
                    
                    print("message : \(message)")
                    
                    if let media = media as? PFObject {
                        media["creationDate"] = NSDate()
                        
                        media.saveInBackgroundWithBlock({ (_, error: NSError?) -> Void in
                            if error == nil {
                                ProgressionData.completeDataProgression()
                                PushNotification.pushNotification("c\(self.event!.objectId!)", message: message)
                                self.checkJoinUser(self.currentEvent!.objectId!)
                            }
                            else {
                                return
                            }
                        })
                    }
                }
            }
            }, progressBlock: { (progress: Int32) -> Void in
                hud.labelText = "Upload en cours (\(progress)%)"
        })
    }
    
    func checkJoinUser(eventId: String) {
        let querry = PFQuery(className: "Participant")
        querry.whereKey("eventId", equalTo: self.currentEvent!)
        querry.whereKey("userId", equalTo: PFUser.currentUser()!)
        
        PushNotification.addNotification("c\(self.currentEvent!.objectId!)")
        
        print("try join \(PFUser.currentUser()!) to \(self.currentEvent!)")
        
        querry.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, _) -> Void in
            if results == nil || results?.count == 0 {
                let newParticipant = PFObject(className: "Participant")
                newParticipant["eventId"] = self.currentEvent!
                newParticipant["userId"] = PFUser.currentUser()!
                newParticipant["approval"] = true
                newParticipant["invited"] = false
                newParticipant["status"] = "accepted"
                newParticipant.saveInBackgroundWithBlock({ (success: Bool, _) -> Void in
                    if success {
                        print("sucess add")

                        if let numberParticipant = self.currentEvent!["nbParticipant"] as? Int {
                            self.currentEvent!["nbParticipant"] = numberParticipant + 1
                            self.currentEvent!.saveInBackgroundWithBlock({ (_, _) -> Void in})
                        }
                        
                        self.dismissViewControllerAnimated(true, completion: { () -> Void in
                            NSNotificationCenter.defaultCenter().postNotificationName("reloadContent", object: nil)
                            NSNotificationCenter.defaultCenter().postNotificationName("dismissCameraController", object: nil)
                        })
                    }
                    else {
                        Alert.error("Erreur lors de l'uplaod de votre Wizz.")
                    }
                })
            }
            else {
                print("results : \(results)")
                print("you are in already")
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName("reloadContent", object: nil)
                    NSNotificationCenter.defaultCenter().postNotificationName("dismissCameraController", object: nil)
                })
            }
        }
    }
}
