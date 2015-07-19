//
//  PrivacyDetailViewController.swift
//  
//
//  Created by Remi Robert on 18/07/15.
//
//

import UIKit

class PrivacyDetailViewController: UIViewController {

    @IBOutlet var codeMoment: UILabel!
    @IBOutlet var imageFlashCode: UIImageView!
    var qrcodeImage: CIImage!
    var password: String!
    
    func generatePassword() -> String {
        var s = NSUUID().UUIDString
        s = s.componentsSeparatedByString("-").first!
        return s
    }
    
    @IBAction func closeController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func copyCodeAccess(sender: AnyObject) {
        UIPasteboard.generalPasteboard().string = password
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        password = generatePassword()
        codeMoment.text = password
        
        let data = password.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        
        qrcodeImage = filter.outputImage
        
        let scaleX = imageFlashCode.frame.size.width / qrcodeImage.extent().size.width
        let scaleY = imageFlashCode.frame.size.height / qrcodeImage.extent().size.height
        let transformedImage = qrcodeImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
        
        imageFlashCode.image = UIImage(CIImage: transformedImage)
    }
}
