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

enum CameraMode {
    case Photo
    case Gif
    case Text
}

class CameraViewController: UIViewController, PBJVisionDelegate, PageController {
    
    @IBOutlet var photoCameraMode: UIButton!
    @IBOutlet var gifCameraMode: UIButton!
    @IBOutlet var textCameraMode: UIButton!
    @IBOutlet var validateGifCaptureButton: UIButton!
    
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var previewView: UIView!
    @IBOutlet var captureButton: UIButton!
    
    @IBOutlet var buttonFlash: UIButton!
    @IBOutlet var buttonRotation: UIButton!
    
    @IBOutlet var photoNumberGif: UILabel!
    @IBOutlet var buttonResetGif: UIButton!
    
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
        vision.focusMode = PBJFocusMode.ContinuousAutoFocus
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
        let alert = Alert()
        
        alert.initAlertViewWithBlock("Voulez vous reset votre GIF ?", completionSuccess: { () -> Void in
            
        }) { () -> Void in
            
        }
    }
    
    //MARK: capture camera mode
    
    @IBAction func changePhotoCameraMode(sender: AnyObject) {
        if currentCameraMode == .Photo {
            return
        }
        buttonResetGif.alpha = 0
        title = "Photo"
        currentCameraMode = .Photo
        textView.resignFirstResponder()
        textView.alpha = 0
        PBJVision.sharedInstance().captureSessionPreset = AVCaptureSessionPresetPhoto
        validateGifCaptureButton.alpha = 0
        photoNumberGif.alpha = 0
        captureButton.setImage(UIImage(named: "ButtonPhoto"), forState: UIControlState.Normal)
        photoCameraMode.alpha = 0.2
        gifCameraMode.alpha = 1
        textCameraMode.alpha = 1
    }
    
    @IBAction func changeGifCameraMode(sender: AnyObject) {
        if currentCameraMode == .Gif {
            return
        }
        buttonResetGif.alpha = 1
        title = "GIF"
        gifImages.removeAll(keepCapacity: false)
        textView.resignFirstResponder()
        textView.alpha = 0
        currentCameraMode = .Gif
        PBJVision.sharedInstance().captureSessionPreset = AVCaptureSessionPresetMedium
        validateGifCaptureButton.alpha = 1
        photoNumberGif.alpha = 1
        photoNumberGif.text = "0"
        captureButton.setImage(UIImage(named: "ButtonGIF"), forState: UIControlState.Normal)
        photoCameraMode.alpha = 1
        gifCameraMode.alpha = 0.2
        textCameraMode.alpha = 1
    }
    
    @IBAction func changeTextCameraMode(sender: AnyObject) {
        if currentCameraMode == .Text {
            return
        }
        buttonResetGif.alpha = 0
        title = "Text"
        textView.text = ""
        textView.alpha = 1
        textView.becomeFirstResponder()
        currentCameraMode = .Text
        validateGifCaptureButton.alpha = 0
        photoNumberGif.alpha = 0
        photoCameraMode.alpha = 1
        gifCameraMode.alpha = 1
        textCameraMode.alpha = 0.2
    }
    
    //MARK: keyboard
    
    func cancelEdit() {
        changePhotoCameraMode(self)
    }
    
    func validateEdit() {
        selectedTextContent = textView.text
        self.performSegueWithIdentifier(SEGUE_PREVIEW_CAPTURE, sender: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            textView.frame.size.height = UIScreen.mainScreen().bounds.size.height - keyboardSize.height - 64 - 44
        }
    }
    
    //MARK: UIView cycle
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        previewLayer.frame = previewView.bounds
        photoNumberGif.text = "0"
        gifImages.removeAll(keepCapacity: false)
        //PBJVision.sharedInstance().startPreview()
        view.bringSubviewToFront(captureButton)
        view.bringSubviewToFront(textView)
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        photoCameraMode.alpha = 0.2
        validateGifCaptureButton.alpha = 0
        photoNumberGif.alpha = 0
        textView.alpha = 0
        buttonResetGif.alpha = 0
        
        textView.contentInset = UIEdgeInsetsMake(24, 0, 10, 0)
        textView.inputAccessoryView = inputViewKeyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_PREVIEW_CAPTURE {
            var media: Media💿!
            switch currentCameraMode {
            case .Photo: media = Media💿.Photo(image: capturedImage)
            case .Gif: media = Media💿.Gif(data: capturedGif)
            case .Text: media = Media💿.Text(content: selectedTextContent)
            default: break
            }
            if let controller = (segue.destinationViewController as! UINavigationController).viewControllers.first as? PreviewCaptureViewController {
                controller.capturedMedia = media
            }
        }
    }
}
