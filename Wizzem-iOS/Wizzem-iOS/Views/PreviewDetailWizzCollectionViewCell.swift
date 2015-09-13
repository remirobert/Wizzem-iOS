//
//  PreviewDetailWizzCollectionViewCell.swift
//  
//
//  Created by Remi Robert on 28/07/15.
//
//

import UIKit

class PreviewDetailWizzCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageContentView: FLAnimatedImageView!
    @IBOutlet var containerDateView: UIView!
    @IBOutlet var optionButton: UIButton!
    @IBOutlet var upButton: UIButton!
    @IBOutlet var authorPictureProfile: FLAnimatedImageView!
    @IBOutlet var buttonDisplayAuthor: UIButton!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var progressTimer: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.authorPictureProfile.layer.cornerRadius = 30
        self.authorPictureProfile.layer.masksToBounds = true
        self.authorPictureProfile.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    func loadData(media: PFObject) {
        self.authorPictureProfile.image = nil
        self.imageContentView.image = nil
        self.imageContentView.animatedImage = nil
        self.progressTimer.setProgress(0, animated: false)
        
        if let author = media["userId"] as? PFObject {
            author.fetchInBackgroundWithBlock({ (author: PFObject?, _) -> Void in
                if let author = author {
                    if let userFile = author["picture"] as? PFFile {
                        userFile.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                if let data = data {
                                    if let dataType = author["typePicture"] as? String where dataType == "GIF" {
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            let animatedImage = FLAnimatedImage(animatedGIFData: data)
                                            self.authorPictureProfile.animatedImage = animatedImage
                                        })
                                    }
                                    else {
                                        self.authorPictureProfile.image = UIImage(data: data)
                                    }
                                }
                            })
                        })
                    }
                }
            })
        }
        
        if let mediaFile = media["file"] as? PFFile {
            mediaFile.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let data = data {
                        switch media["type"] as! String {
                        case "photo": self.imageContentView.image = UIImage(data: data)
                        case "gif": self.imageContentView.animatedImage = FLAnimatedImage(animatedGIFData: data)
                        default: return
                        }
                        self.imageContentView.contentMode = UIViewContentMode.ScaleAspectFit
                        self.contentView.bringSubviewToFront(self.authorPictureProfile)
                        self.contentView.bringSubviewToFront(self.containerDateView)
                        self.contentView.bringSubviewToFront(self.upButton)
                        self.contentView.bringSubviewToFront(self.optionButton)
                    }
                })
            })
        }
        
        if let dateFile = media["creationDate"] as? NSDate {
            let formatString = dateFile.formattedDateWithFormat("dd/MM")
            let formatStringHour = dateFile.formattedDateWithFormat("h:mm")
            self.hourLabel.text = "\(formatStringHour)"
            self.dateLabel.text = "Le \(formatString)"
        }
        
        if let dateFile = media.createdAt {
            
            let distanceBetweenDates = NSDate().timeIntervalSinceDate(dateFile)
            let realHoursDiff = distanceBetweenDates / 3600
            
            var pourcent = 72 * realHoursDiff / 100
            
            switch pourcent {
            case 0...25: self.progressTimer.progressTintColor = UIColor.greenColor()
            case 25...50: self.progressTimer.progressTintColor = UIColor.yellowColor()
            case 50...75: self.progressTimer.progressTintColor = UIColor.orangeColor()
            case 75...100: self.progressTimer.progressTintColor = UIColor.redColor()
            default: Void()
            }
            
            pourcent = 100 - pourcent
            
            self.progressTimer.setProgress(Float(pourcent) / 100, animated: true)
        }
    }
}
