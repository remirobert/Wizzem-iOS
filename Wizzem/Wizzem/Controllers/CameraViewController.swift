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

class CameraViewController: UIViewController, PBJVisionDelegate {
    
    @IBOutlet var photoCameraMode: UIButton!
    @IBOutlet var gifCameraMode: UIButton!
    @IBOutlet var textCameraMode: UIButton!
    @IBOutlet var validateGifCaptureButton: UIButton!
    
    @IBOutlet var previewView: UIView!
    @IBOutlet var captureButton: UIButton!
    
    @IBOutlet var buttonFlash: UIButton!
    @IBOutlet var buttonRotation: UIButton!
    
    @IBOutlet var photoNumberGif: UILabel!
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    var capturedImage: UIImage!
    var capturedGif: NSData!
    var gifImages = Array<UIImage>()
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
                    gifImages.append(photo)
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
    
    //MARK: capture camera mode
    
    @IBAction func changePhotoCameraMode(sender: AnyObject) {
        if currentCameraMode == .Photo {
            return
        }
        currentCameraMode = .Photo
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
        gifImages.removeAll(keepCapacity: false)
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
        currentCameraMode = .Text
        validateGifCaptureButton.alpha = 0
        photoNumberGif.alpha = 0
        photoCameraMode.alpha = 1
        gifCameraMode.alpha = 1
        textCameraMode.alpha = 0.2
    }
    
    //MARK: UIView cycle
    
    override func viewWillDisappear(animated: Bool) {
        PBJVision.sharedInstance().stopPreview()
    }
    
    override func viewDidAppear(animated: Bool) {
        setupCamera()
        gifImages.removeAll(keepCapacity: false)
        PBJVision.sharedInstance().startPreview()
        view.bringSubviewToFront(captureButton)
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCameraMode.alpha = 0.2
        validateGifCaptureButton.alpha = 0
        photoNumberGif.alpha = 0
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_PREVIEW_CAPTURE {
            if let capturedImage = capturedImage {
                var media: Media💿!
                switch currentCameraMode {
                case .Photo: media = Media💿.Photo(image: capturedImage)
                case .Gif: media = Media💿.Gif(data: capturedGif)
                default: break
                }
                (segue.destinationViewController as! PreviewCaptureViewController).capturedMedia = media
            }
        }
    }
}
