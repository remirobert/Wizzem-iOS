//
//  PreviewDetailWizzCollectionViewCell.swift
//  
//
//  Created by Remi Robert on 28/07/15.
//
//

import UIKit
import FLAnimatedImage
import Parse

class PreviewDetailWizzCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageContentView: FLAnimatedImageView!
    @IBOutlet var authorPictureImageView: UIImageView!
    @IBOutlet var authorUsernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func loadData(media: PFObject) {
        self.authorPictureImageView.image = nil
        self.authorUsernameLabel.text = nil
        self.imageContentView.image = nil
                
        if let author = media["userId"] as? PFObject {
            if let username = author["true_username"] as? String {
                authorUsernameLabel.text = username
            }
            if let userFile = author["picture"] as? PFFile {
                userFile.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                    if let data = data {
                        self.authorPictureImageView.image = UIImage(data: data)
                    }
                })
            }
        }
        
        if let mediaFile = media["file"] as? PFFile {
            mediaFile.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                if let data = data {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        switch media["type"] as! String {
                        case "photo": self.imageContentView.image = UIImage(data: data)
                        case "gif": self.imageContentView.animatedImage = FLAnimatedImage(animatedGIFData: data)
                        default: return
                        }
                        self.imageContentView.contentMode = UIViewContentMode.ScaleAspectFill
                    })
                }
            })
        }
    }
}
