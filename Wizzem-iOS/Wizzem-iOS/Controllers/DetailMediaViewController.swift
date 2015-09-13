//
//  DetailMediaViewController.swift
//  
//
//  Created by Remi Robert on 12/07/15.
//
//

import UIKit

class DetailMediaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, QBImagePickerControllerDelegate {

    var currentEvent: PFObject!
    var currentMedia: PFObject!
    var currentIndex: Int!
    var dataMedia: NSData!
    var medias = Array<PFObject>()
    var isParticipant: Bool?
    var pickerMedia: QBImagePickerController!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var collectionViewLayout: UICollectionViewFlowLayout!
    
    @IBAction func closeController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func displayDetailProfile() {
        let media = self.medias[self.currentIndex - 1]
        if let author = media["userId"] as? PFObject {
            self.performSegueWithIdentifier("detailProfileSegue", sender: author)
        }
    }
    
    func invteByLink() {
        if let eventId = currentEvent.objectId {
            let activityController = UIActivityViewController(activityItems: ["wizzem://?eventId=\(eventId)"], applicationActivities: nil)
            self.presentViewController(activityController, animated: true, completion: nil)
        }
    }
    
    func displayParticipantList() {
        if let isParticipant = self.isParticipant where isParticipant == true {
            self.performSegueWithIdentifier("participantListSegue", sender: nil)
        }
        else {
            Alert.error("Publiez un média, pour participer, et voir la liste des participants")
        }
    }
    
    func qb_imagePickerController(imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let datas = Array<NSData>()
        let manager = PHImageManager.defaultManager()
        
        var medias = Array<NSData>()
        var creationDates = Array<NSDate>()
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .FastFormat
        options.resizeMode = .None
        options.synchronous = true
        options.networkAccessAllowed = false
        
        
        for asset in assets {
//            
//            manager.requestImageDataForAsset(asset as! PHAsset, options: options, resultHandler: { (data: NSData!, _, _, _) -> Void in
//                
//                println("data = \(data)")
//                
//                if let data = data {
//                    medias.append(data)
//                    creationDates.append((asset as! PHAsset).creationDate)
//                    
//                    if medias.count == assets.count {
//                        var mediaUpload = MediaUpload()
//                        
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            mediaUpload.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                        })
//                        mediaUpload.event = self.currentEvent
//                        mediaUpload.currentCount = 0
//                        mediaUpload.medias = medias
//                        mediaUpload.creationDates = creationDates
//                        
//                        mediaUpload.completion = {
//                            NSNotificationCenter.defaultCenter().postNotificationName("reloadContent", object: nil)
//                        }
//                        mediaUpload.addMedia()
//                    }
//                }
//            })
        
            println("current size image : \((asset as! PHAsset).pixelWidth) / \((asset as! PHAsset).pixelHeight)")
            
            manager.requestImageForAsset(asset as! PHAsset,
                targetSize: CGSizeMake(CGFloat((asset as! PHAsset).pixelWidth * Int(UIScreen.mainScreen().scale)),
                    CGFloat((asset as! PHAsset).pixelHeight * Int(UIScreen.mainScreen().scale))),
                contentMode: PHImageContentMode.AspectFit,
                options: options,
                resultHandler: { (image: UIImage!, _) -> Void in
                    
                    if let image = image, let data = UIImageJPEGRepresentation(image, 1) {
                        
                        medias.append(data)
                        creationDates.append((asset as! PHAsset).creationDate)
                        
                        if medias.count == assets.count {
                            var mediaUpload = MediaUpload()
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                mediaUpload.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            })
                            mediaUpload.event = self.currentEvent
                            mediaUpload.currentCount = 0
                            mediaUpload.medias = medias
                            mediaUpload.creationDates = creationDates
                            
                            mediaUpload.completion = {
                                NSNotificationCenter.defaultCenter().postNotificationName("reloadContent", object: nil)
                            }
                            mediaUpload.addMedia()
                        }
                    }
            })
        }
    }
    
    func qb_imagePickerControllerDidCancel(imagePickerController: QBImagePickerController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addMedia() {
        
        let controller = UIAlertController(title: "Ajouter un média à ce moment", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let galleriAction = UIAlertAction(title: "Depuis la gallerie", style: UIAlertActionStyle.Default) { (_) -> Void in
            self.pickerMedia = QBImagePickerController()
            self.pickerMedia.allowsMultipleSelection = true
            self.pickerMedia.maximumNumberOfSelection = 6
            self.pickerMedia.showsNumberOfSelectedAssets = true
            self.pickerMedia.maximumNumberOfSelection = 10
            self.pickerMedia.mediaType = QBImagePickerMediaType.Image
            self.pickerMedia.delegate = self
            self.presentViewController(self.pickerMedia, animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(title: "Capturer depuis la camera", style: UIAlertActionStyle.Default) { (_) -> Void in
            self.performSegueWithIdentifier("addMediaSegue", sender: self.currentEvent)
        }
        
        let cancelAction = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.Cancel) { (_) -> Void in }
        
        controller.addAction(galleriAction)
        controller.addAction(cameraAction)
        controller.addAction(cancelAction)
        
        self.presentViewController(controller, animated: true, completion: nil)
        //self.performSegueWithIdentifier("addMediaSegue", sender: self.currentEvent)
    }
    
    func upToDetailMoment() {
        self.collectionView.setContentOffset(CGPointZero, animated: true)
    }
    
    func displayDescriptionDetail() {
        self.performSegueWithIdentifier("detailDescriptionSegue", sender: self.currentEvent["description"] as! String)
    }
    
    func downToDetailMoment() {
        if self.medias.count > 0 {
            self.collectionView.setContentOffset(CGPointMake(0, CGRectGetHeight(UIScreen.mainScreen().bounds)), animated: true)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medias.count + 1
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        
        self.currentIndex = indexPath.row
        
        if indexPath.row > 0 {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellPreview", forIndexPath: indexPath) as! PreviewDetailWizzCollectionViewCell
            (cell as! PreviewDetailWizzCollectionViewCell).loadData(medias[indexPath.row - 1])
            (cell as! PreviewDetailWizzCollectionViewCell).upButton.addTarget(self, action: "upToDetailMoment", forControlEvents: UIControlEvents.TouchUpInside)
            
            (cell as! PreviewDetailWizzCollectionViewCell).buttonDisplayAuthor.addTarget(self, action: "displayDetailProfile", forControlEvents: UIControlEvents.TouchUpInside)
            (cell as! PreviewDetailWizzCollectionViewCell).optionButton.addTarget(self, action: "displayOptions", forControlEvents: UIControlEvents.TouchUpInside)
        }
        else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("detailMomentCell", forIndexPath: indexPath) as! DetailMomentCollectionViewCell
            (cell as! DetailMomentCollectionViewCell).loadDetailMoment(self.currentEvent)
            (cell as! DetailMomentCollectionViewCell).addMediaButton.addTarget(self, action: "addMedia", forControlEvents: UIControlEvents.TouchUpInside)
            (cell as! DetailMomentCollectionViewCell).settingButton.addTarget(self, action: "displayOptionMoment", forControlEvents: UIControlEvents.TouchUpInside)
            (cell as! DetailMomentCollectionViewCell).downbutton.addTarget(self, action: "downToDetailMoment", forControlEvents: UIControlEvents.TouchUpInside)
            (cell as! DetailMomentCollectionViewCell).inviteLink.addTarget(self, action: "invteByLink", forControlEvents: UIControlEvents.TouchUpInside)
            (cell as! DetailMomentCollectionViewCell).participantLabel.addTarget(self, action: "displayParticipantList", forControlEvents: UIControlEvents.TouchUpInside)

            (cell as! DetailMomentCollectionViewCell).buttonDisplayDescription.addTarget(self, action: "displayDescriptionDetail", forControlEvents: UIControlEvents.TouchUpInside)
            
            if let creator = currentEvent["creator"] as? PFUser {
                if (currentEvent["creator"] as! PFObject).objectId! != PFUser.currentUser()?.objectId! {
                    (cell as! DetailMomentCollectionViewCell).settingButton.alpha = 0
                }
                else {
                    (cell as! DetailMomentCollectionViewCell).settingButton.alpha = 1
                }
            }
            else {
                (cell as! DetailMomentCollectionViewCell).settingButton.alpha = 1
            }
        }
        return cell

    }
    
    func refreshEvent() {
        let querry = PFQuery(className: "Event")
        querry.whereKey("objectId", equalTo: currentEvent.objectId!)
        
        querry.getFirstObjectInBackgroundWithBlock { (event: PFObject?, _) -> Void in
            if let event = event {
                self.currentEvent = event
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchMedia() {
        let querry = PFQuery(className: "Media")
        querry.whereKey("eventId", equalTo: currentEvent!)
        
        querry.orderByDescending("creationDate")
        
        querry.cachePolicy = PFCachePolicy.NetworkOnly
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        querry.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, _) -> Void in
            hud.hide(true)
            
            if let results = results as? [PFObject] {
                self.medias = results
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EventCloud.checkParticipantToEvent(self.currentEvent, blockParticipant: { (isParticipant) -> Void in
            self.isParticipant = isParticipant
        })
        
        NSNotificationCenter.defaultCenter().addObserverForName("reloadContent", object: nil, queue: nil) { (_) -> Void in
            self.refreshEvent()
            self.fetchMedia()
        }
        self.fetchMedia()
        
        self.navigationController
        self.collectionViewLayout.itemSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds))
        self.collectionViewLayout.minimumInteritemSpacing = 0
        self.collectionViewLayout.minimumLineSpacing = 0

        self.collectionView.registerNib(UINib(nibName: "DetailMomentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "detailMomentCell")
        self.collectionView.registerNib(UINib(nibName: "PreviewDetailWizzCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellPreview")
        
        self.collectionView.pagingEnabled = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectMediaSegue" {
            (segue.destinationViewController as! SelectionMediaViewController).currentIndex = self.currentIndex - 1
            (segue.destinationViewController as! SelectionMediaViewController).currentEvent = self.currentEvent
            (segue.destinationViewController as! SelectionMediaViewController).blockSelectionCell = {(index: Int) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let indexPos = CGRectGetHeight(UIScreen.mainScreen().bounds) * CGFloat((index + 1))
                    
                    self.collectionView.setContentOffset(CGPointMake(0, CGFloat(indexPos)), animated: true)
                })
            }
        }
        else if segue.identifier == "addMediaSegue" {
            (segue.destinationViewController as! CameraViewController).event = sender as? PFObject
        }
        else if segue.identifier == "detailProfileSegue" {
            (segue.destinationViewController as! DetailProfileViewController).user = sender as! PFObject
        }
        else if segue.identifier == "participantListSegue" {
            (segue.destinationViewController as! ParticipantListViewController).currentMoment = self.currentEvent
        }
        else if segue.identifier == "detailDescriptionSegue" {
            (segue.destinationViewController as! DetailDescriptionViewController).content = sender as! String
            (segue.destinationViewController as! DetailDescriptionViewController).titleEventContent = (self.currentEvent["title"] as? String)!
        }
    }
}

extension DetailMediaViewController {
    func displayOptionMoment() {
        let alertController = UIAlertController(title: "Options moment", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let removeAction = UIAlertAction(title: "Supprimer", style: UIAlertActionStyle.Destructive) { (_) -> Void in
            
            let param = NSMutableDictionary()
            param.setValue(self.currentEvent.objectId!, forKey: "eventId")
            println("param : \(param)")
            
            let querry = PFQuery(className: "Participant")
            querry.whereKey("eventId", equalTo: self.currentEvent)
            
            querry.findObjectsInBackgroundWithBlock({ (participants: [AnyObject]?, _) -> Void in
                if let participants = participants as? [PFObject] {
                    PFObject.deleteAllInBackground(participants, block: { (_, err: NSError?) -> Void in
                        if err == nil {
                            PFCloud.callFunctionInBackground("EventRemove",
                                withParameters: param as [NSObject : AnyObject],
                                block: { (_, error: NSError?) -> Void in

                                    if error == nil {
                                        self.dismissViewControllerAnimated(true, completion: nil)
                                    }
                            })
                        }
                    })
                }
            })
        }
        
        let report = UIAlertAction(title: "Reporter le moment", style: UIAlertActionStyle.Default) { (_) -> Void in
            Report.send("salut test")
        }
        
        let cancelButton = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.Cancel, handler: nil)

        if let creator = currentEvent["creator"] as? PFObject {
            if creator.objectId! == PFUser.currentUser()?.objectId! {
                alertController.addAction(removeAction)
            }
        }
        alertController.addAction(report)
        alertController.addAction(cancelButton)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func displayOptions() {
        if (self.currentIndex <= 0) {
            return
        }
        let alertController = UIAlertController(title: "Options media", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let removeAction = UIAlertAction(title: "Supprimer", style: UIAlertActionStyle.Destructive) { (_) -> Void in
            let param = NSMutableDictionary()
            let currenMediaSelect = self.medias[self.currentIndex - 1]
            param.setValue(currenMediaSelect.objectId!, forKey: "mediaId")
            
            PFCloud.callFunctionInBackground("MediaRemove", withParameters: param as [NSObject : AnyObject], block: { (_, err: NSError?) -> Void in
                if err == nil {
                    self.fetchMedia()
                }
                else {
                    Alert.error("Impossible de supprimer votre Wizz.")
                }
                
                
            })
        }
        
        let shareAction = UIAlertAction(title: "Partager", style: UIAlertActionStyle.Default) { (_) -> Void in
            let currenMediaSelect = self.medias[self.currentIndex - 1]
            
            if let file = currenMediaSelect["file"] as? PFFile {
                file.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                    if let data = data {
                        let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                        self.presentViewController(activityController, animated: true, completion: nil)
                    }
                })
            }
        }
        
        let saveMediaAction = UIAlertAction(title: "Sauvegarder le media", style: UIAlertActionStyle.Default) { (_) -> Void in
            let currenMediaSelect = self.medias[self.currentIndex - 1]
            
            if let file = currenMediaSelect["file"] as? PFFile {
                file.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                    if let data = data {
                        let ala = ALAssetsLibrary()
                        ala.writeImageDataToSavedPhotosAlbum(data, metadata: nil, completionBlock: { (_, error: NSError!) -> Void in
                            println("error:  \(error)")
                        })
                    }
                })
            }
        }

        let setProfilePictureAction = UIAlertAction(title: "Défénir comme photo de profile", style: UIAlertActionStyle.Default) { (_) -> Void in
            
            let currentMediaSelect = self.medias[self.currentIndex - 1]
            if let file = currentMediaSelect["file"] as? PFFile {
                file.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                    if let data = data {
                        if currentMediaSelect["type"] as! String == "gif" {
                            self.updateProfile(data, type: "GIF")
                        }
                        else {
                            self.updateProfile(data, type: "JPG")
                        }
                    }
                })
            }
        }
        
        let cancelButton = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(shareAction)
        alertController.addAction(saveMediaAction)
        alertController.addAction(setProfilePictureAction)
        
        let currenMediaSelect = self.medias[self.currentIndex - 1]
        if (currenMediaSelect["userId"] as! PFObject).objectId! == PFUser.currentUser()?.objectId! {
            alertController.addAction(removeAction)
        }
        
        alertController.addAction(cancelButton)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension DetailMediaViewController {
    func updateProfile(imageData: NSData, type: String) {
        if let user = PFUser.currentUser() {
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            let fileImage = PFFile(data: imageData)
            fileImage.saveInBackgroundWithBlock({ (success: Bool, _) -> Void in
                if success {
                    
                    user["typePicture"] = type
                    user["picture"] = fileImage
                    user.saveInBackgroundWithBlock({ (success: Bool, _) -> Void in
                        if success {
                            hud.hide(true)
                        }
                        else {
                            hud.hide(true)
                            Alert.error("Impossible de changer votre image de profile")
                        }
                    })
                }
                else {
                    hud.hide(true)
                    Alert.error("Impossible de changer votre image de profile")
                }
            })
        }
    }
}
