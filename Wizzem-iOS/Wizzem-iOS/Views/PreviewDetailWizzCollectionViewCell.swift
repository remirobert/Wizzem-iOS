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
    @IBOutlet var authorPicture: UIButton!
    @IBOutlet var containerDateView: UIView!
    @IBOutlet var optionButton: UIButton!
    @IBOutlet var upButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.authorPicture.layer.cornerRadius = 20
//        self.authorPicture.layer.masksToBounds = true
    }
    
    func loadData(media: PFObject) {
        self.authorPicture.setImage(nil, forState: UIControlState.Normal)
        
//                    if let author = media["userId"] as? PFObject {
//                        author.fetchIfNeededInBackgroundWithBlock({ (author: PFObject?, _) -> Void in
//                            if let author = author {
//                                if let userFile = author["picture"] as? PFFile {
//                                    userFile.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
//                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                            if let data = data {
//                                                self.authorPicture.setImage(UIImage(data: data), forState: UIControlState.Normal)
//                                            }
//                                        })
//                                    })
//                                }
//                            }
//                        })
//                    }
        
                    if let mediaFile = media["file"] as? PFFile {
                        mediaFile.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                if let data = data {
                                    switch media["type"] as! String {
                                    case "photo": self.imageContentView.image = UIImage(data: data)
                                    case "gif": self.imageContentView.animatedImage = FLAnimatedImage(animatedGIFData: data)
                                    default: return
                                    }
                                    self.imageContentView.contentMode = UIViewContentMode.ScaleAspectFill
                                    self.contentView.bringSubviewToFront(self.authorPicture)
                                    self.contentView.bringSubviewToFront(self.containerDateView)
                                    self.contentView.bringSubviewToFront(self.upButton)
                                    self.contentView.bringSubviewToFront(self.optionButton)
                                }
                            })
                        })
                    }
        
    }
}
