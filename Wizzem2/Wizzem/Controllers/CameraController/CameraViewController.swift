//
//  CameraViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 13/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit
import PBJVision
import MBProgressHUD
import Parse

enum CameraMode {
    case Photo
    case Gif
    case Text
}

class CameraViewController: UIViewController, PBJVisionDelegate, PageController {
    
    @IBOutlet var photoCameraMode: UIButton!
    @IBOutlet var gifCameraMode: UIButton!
    @IBOutlet var validateGifCaptureButton: UIButton!
    
    
    @IBOutlet var previewView: UIView!
    @IBOutlet var captureButton: UIButton!
    
    @IBOutlet var buttonFlash: UIButton!
    @IBOutlet var buttonRotation: UIButton!
    
    @IBOutlet var photoNumberGif: UILabel!
    @IBOutlet var buttonResetGif: UIButton!
    
    @IBOutlet var cancelCameraButton: UIButton!
    
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
    
    func setupCamera() {
        previewLayer = PBJVision.sharedInstance().previewLayer
        previewLayer.frame = previewView.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewView.layer.addSublayer(previewLayer)

        let vision = PBJVision.sharedInstance()
        vision.delegate = self
        vision.captureSessionPreset = AVCaptureSessionPresetPhoto
        vision.autoFreezePreviewDuringCapture = false
        vision.cameraMode = PBJCameraMode.Photo
        vision.cameraOrientation = PBJCameraOrientation.Portrait
        vision.focusMode = PBJFocusMode.ContinuousAutoFocus
        vision.outputFormat = PBJOutputFormat.Standard
    }
    
    //MARK: PBJVision delegate
    
    func vision(vision: PBJVision, capturedPhoto photoDict: [NSObject : AnyObject]?, error: NSError?) {
        if let photo = photoDict![PBJVisionPhotoImageKey] as? UIImage {
            if currentCameraMode == .Photo {
                capturedImage = photo
                performSegueWithIdentifier(SEGUE_PREVIEW_CAPTURE, sender: nil)
            }
            else {
                if let photo = UIImage(data: UIImageJPEGRepresentation(photo, 0.5)) {
                    gifImages.append(PhotoHelper.fixOrientationOfImage(photo))
                    if gifImages.count > 1 {
                        buttonResetGif.alpha = 1
                        validateGifCaptureButton.alpha = 1
                    }
                    photoNumberGif.text = "\(gifImages.count)"
                    PBJVision.sharedInstance().startPreview()
                }
            }
        }
    }

    //MARK: camera fonctionnality
    
    @IBAction func activateFlash(sender: AnyObject) {
        let vision = PBJVision.sharedInstance()
        if vision.flashMode == PBJFlashMode.Off {
           vision.flashMode = PBJFlashMode.On
            buttonFlash.setImage(UIImage(named: "IconFlashOn"), forState: UIControlState.Normal)
        }
        else {
            vision.flashMode = PBJFlashMode.Off
            buttonFlash.setImage(UIImage(named: "IconFlash"), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func rotationCamera(sender: AnyObject) {
        let vision = PBJVision.sharedInstance()
        if vision.cameraDevice == PBJCameraDevice.Back {
            vision.cameraDevice = PBJCameraDevice.Front
            buttonRotation.setImage(UIImage(named: "IconSelfieOn"), forState: UIControlState.Normal)
        }
        else {
            vision.cameraDevice = PBJCameraDevice.Back
            buttonRotation.setImage(UIImage(named: "IconSelfie"), forState: UIControlState.Normal)
        }
    }
    
    //MARK: capture action
    
    @IBAction func captureMedia(sender: AnyObject) {
        PBJVision.sharedInstance().capturePhoto()
    }
    
    @IBAction func validateGifCapture(sender: AnyObject) {
        if gifImages.count == 0 {
            return
        }
        
        
        var hud: MBProgressHUD!
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "Making GIF"
        })
        
        
        GifMaker().makeAnimatedGif(gifImages, blockCompletion: { (dataGif: NSData!) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                hud.hide(true)
            })
            if let datagif = dataGif {
                self.capturedGif = datagif
                self.performSegueWithIdentifier(SEGUE_PREVIEW_CAPTURE, sender: nil)
            }
        })
    }
    
    @IBAction func resetGif(sender: AnyObject) {
        let alertController = UIAlertController(title: "Voulez vous reset votre GIF ?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let actionValidate = UIAlertAction(title: "Oui", style: UIAlertActionStyle.Default) { (_) -> Void in
            self.gifImages.removeAll(keepCapacity: false)
            self.buttonResetGif.alpha = 0
            self.validateGifCaptureButton.alpha = 0
            self.photoNumberGif.text = "0"
        }
        let cancelAction = UIAlertAction(title: "Non", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(actionValidate)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: capture camera mode
    
    @IBAction func changePhotoCameraMode(sender: AnyObject) {
        if currentCameraMode == .Photo {
            return
        }
        buttonResetGif.alpha = 0
        title = "Photo"
        currentCameraMode = .Photo
        PBJVision.sharedInstance().captureSessionPreset = AVCaptureSessionPresetPhoto
        validateGifCaptureButton.alpha = 0
        photoNumberGif.alpha = 0
        captureButton.setImage(UIImage(named: "ButtonPhoto"), forState: UIControlState.Normal)
        photoCameraMode.alpha = 0.2
        gifCameraMode.alpha = 1
        buttonResetGif.alpha = 0
        validateGifCaptureButton.alpha = 0
    }
    
    @IBAction func changeGifCameraMode(sender: AnyObject) {
        if currentCameraMode == .Gif {
            return
        }
        buttonResetGif.alpha = 1
        title = "GIF"
        gifImages.removeAll(keepCapacity: false)
        currentCameraMode = .Gif
        PBJVision.sharedInstance().captureSessionPreset = AVCaptureSessionPresetMedium
        validateGifCaptureButton.alpha = 1
        photoNumberGif.alpha = 1
        photoNumberGif.text = "0"
        captureButton.setImage(UIImage(named: "ButtonGIF"), forState: UIControlState.Normal)
        photoCameraMode.alpha = 1
        gifCameraMode.alpha = 0.2
        buttonResetGif.alpha = 0
        validateGifCaptureButton.alpha = 0
    }
    
    //MARK: UIView cycle
    
    @IBAction func dismissCameraController(sender: AnyObject) {
        dismissController()
    }
    
    func dismissController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        PBJVision.sharedInstance().stopPreview()
    }

    override func viewDidAppear(animated: Bool) {
        previewLayer.frame = previewView.bounds
        photoNumberGif.text = "0"
        gifImages.removeAll(keepCapacity: false)
        //PBJVision.sharedInstance().startPreview()
        view.bringSubviewToFront(captureButton)
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewWillAppear(animated: Bool) {
        PBJVision.sharedInstance().startPreview()
    }
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "dismissController", name: "dismissCameraController", object: nil)
        super.viewDidLoad()
        setupCamera()
        photoCameraMode.alpha = 0.2
        validateGifCaptureButton.alpha = 0
        photoNumberGif.alpha = 0
        buttonResetGif.alpha = 0
        
        if let event = event {
            cancelCameraButton.alpha = 1
        }
        else {
            cancelCameraButton.alpha = 0
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_PREVIEW_CAPTURE {
            var media: Media💿!
            switch currentCameraMode {
            case .Photo: media = Media💿.Photo(image: capturedImage)
            case .Gif: media = Media💿.Gif(data: capturedGif)
            default: break
            }
            if let controller = (segue.destinationViewController as! UINavigationController).viewControllers.first as? PreviewCaptureViewController {
                controller.capturedMedia = media
                controller.event = event
            }
        }
    }
}
