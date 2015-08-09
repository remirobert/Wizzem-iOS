//
//  ParticipantTableViewCell.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 09/08/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class ParticipantTableViewCell: UITableViewCell {

    @IBOutlet var pictureProfile: UIImageView!
    @IBOutlet var nameParticipant: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pictureProfile.image = nil
        nameParticipant.text = nil
    }
    
    func loadParticipant(user: PFObject) {
        pictureProfile.image = nil
        nameParticipant.text = nil

        user.fetchIfNeededInBackgroundWithBlock { (user: PFObject?, _) -> Void in
            if let user = user {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.nameParticipant.text = user["true_username"] as? String
                })
                
                let file = user["picture"] as? PFFile
                file?.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if let data = data {
                            self.pictureProfile.image = UIImage(data: data)
                        }
                    })
                })
            }
        }
    }
}
