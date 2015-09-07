//
//  CameraViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 13/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

enum CameraMode {
    case Photo
    case Gif
    case Text
}

class CameraViewController: UIViewController, PBJVisionDelegate, PageController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var validateGifCaptureButton: UIButton!
    @IBOutlet var previewView: UIView!
    
    @IBOutlet var buttonFlash: UIButton!
    @IBOutlet var buttonRotation: UIButton!
    
    @IBOutlet var photoNumberGif: UILabel!
    @IBOutlet var buttonGallerie: UIButton!
    @IBOutlet var buttonLibrairi: UIButton!
    
    var event: PFObject?
    var page: Int = 1
    
    
    lazy var inputViewKeyboard: UIToolbar! = {
        let inputView = UIToolbar()
        inputView.frame.size = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 44)
        let cancelButton = UIBarButtonItem(title: "Annuler", style: UIBarButtonItemStyle.Done, target: self, action: "cancelEdit")
        let valideButton = UIBarButtonItem(title: "Valider", style: UIBarButtonItemStyle.Done, target: self, action: "validateEdit")
        
        inputView.items = [cancelButton, valideButton]
        return inputView
    }()
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    var capturedImage: UIImage!
    var capturedGif: NSData!
    var gifImages = Array<UIImage>()
    var selectedTextContent: String!
    var currentCameraMode: CameraMode = CameraMode.Photo
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            capturedImage = image
            photoNumberGif.text = "0"
            gifImages.removeAll(keepCapacity: false)
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.performSegueWithIdentifier(SEGUE_PREVIEW_CAPTURE, sender: nil)
            })
        }
        else {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    Alert.error("Impossible de charger le contenu.")
                })
            })
        }
    }
    
    @IBAction func pickPhotoGallerie(sender: AnyObject) {
        let controller = UIImagePickerController()
        controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        controller.delegate = self
        self.presentViewController(controller, animated: true, completion: nil)        
    }
    
    @IBAction func swipeFeedController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupCamera() {
        previewLayer = PBJVision.sharedInstance().previewLayer
        previewLayer.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds))
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewView.layer.addSublayer(previewLayer)

        let vision = PBJVision.sharedInstance()
        vision.delegate = self
        vision.captureSessionPreset = AVCaptureSessionPresetHigh
        vision.autoFreezePreviewDuringCapture = false
        vision.cameraMode = PBJCameraMode.Photo
        vision.cameraOrientation = PBJCameraOrientation.Portrait
        vision.focusMode = PBJFocusMode.ContinuousAutoFocus
        vision.outputFormat = PBJOutputFormat.Widescreen
        
        vision.startPreview()
    }
    
    //MARK: PBJVision delegate
    
    func vision(vision: PBJVision, capturedPhoto photoDict: [NSObject : AnyObject]?, error: NSError?) {
        if let photo = photoDict![PBJVisionPhotoImageKey] as? UIImage {
            let photoFixed = PhotoHelper.fixOrientationOfImage(photo)
            if gifImages.count == 0 {
                gifImages.append(photoFixed)
            }
            else {
                //let compressedImage = UIImage(data: UIImageJPEGRepresentation(photoFixed, 0.1))!
                self.buttonLibrairi.alpha = 0
                gifImages.append(photoFixed)
            }
//            if gifImages.count == 2 {
//                let compressedImage = UIImage(data: UIImageJPEGRepresentation(gifImages.first, 0.1))!
//                gifImages[0] = (PhotoHelper.compraseImage(compressedImage))
//            }
            validateGifCaptureButton.alpha = 1
            photoNumberGif.text = "\(gifImages.count)"

            if gifImages.count == 10 {
                validateGifCapture(self)
            }
        }
    }

    //MARK: camera fonctionnality
    
    @IBAction func activateFlash(sender: AnyObject) {
        let vision = PBJVision.sharedInstance()
        if vision.flashMode == PBJFlashMode.Off {
           vision.flashMode = PBJFlashMode.On
            buttonFlash.setImage(UIImage(named: "FlashOn"), forState: UIControlState.Normal)
        }
        else {
            vision.flashMode = PBJFlashMode.Off
            buttonFlash.setImage(UIImage(named: "FlashOff"), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func rotationCamera(sender: AnyObject) {
        let vision = PBJVision.sharedInstance()
        if vision.cameraDevice == PBJCameraDevice.Back {
            vision.cameraDevice = PBJCameraDevice.Front
        }
        else {
            vision.cameraDevice = PBJCameraDevice.Back
        }
    }
    
    //MARK: capture action
    
    func captureMedia() {
        if gifImages.count >= 15 {
            return
        }
        PBJVision.sharedInstance().capturePhoto()
    }
    
    @IBAction func validateGifCapture(sender: AnyObject) {
        if gifImages.count == 0 {
            return
        }
        
        if self.gifImages.count == 1 {
            currentCameraMode = .Photo
            capturedImage = gifImages.first
            performSegueWithIdentifier(SEGUE_PREVIEW_CAPTURE, sender: nil)
        }
        else {
            currentCameraMode = .Gif
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "Creation de la preview"
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                GifMaker().makeAnimatedGif(self.gifImages, blockCompletion: { (dataGif: NSData!) -> Void in
                    hud.hide(true)
                    if let datagif = dataGif {
                        self.capturedGif = datagif
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.performSegueWithIdentifier(SEGUE_PREVIEW_CAPTURE, sender: nil)
                        })
                    }
                })
            })
        }
    }
    
    //MARK: UIView cycle
        
    func dismissController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        photoNumberGif.text = "0"
        gifImages.removeAll(keepCapacity: false)
        validateGifCaptureButton.alpha = 0
        buttonLibrairi.alpha = 1
    }
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "dismissController", name: "dismissCameraController", object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: "captureMedia")
        self.previewView.addGestureRecognizer(tapGesture)
        super.viewDidLoad()
        setupCamera()
        validateGifCaptureButton.alpha = 0
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_PREVIEW_CAPTURE {
            var media: Media💿!
            switch currentCameraMode {
            case .Photo: media = Media💿.Photo(image: capturedImage)
            case .Gif: media = Media💿.Gif(data: capturedGif, frames: gifImages)
            default: break
            }
            if let controller = (segue.destinationViewController as! UINavigationController).viewControllers.first as? PreviewCaptureViewController {
                controller.capturedMedia = media
                controller.event = event
            }
        }
    }
}
