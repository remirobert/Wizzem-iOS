//
//  DetailMomentCollectionViewCell.swift
//  
//
//  Created by Remi Robert on 30/07/15.
//
//

import UIKit
import Parse

class DetailMomentCollectionViewCell: UICollectionViewCell {

    @IBOutlet var titleEvent: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var numberWizzLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var participantLabel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func loadDetailMoment(moment: PFObject) {
        if let title = moment["title"] as? String {
            self.titleEvent.text = title
        }
        if let description = moment["description"] as? String {
            self.descriptionLabel.text = description
        }
        if let author = moment["creator"] as? PFUser {
            author.fetchIfNeededInBackgroundWithBlock({ (user: PFObject?, _) -> Void in
                if let user = user {
                    if let username = user["true_username"] as? String {
                        self.authorLabel.text = username
                    }
                }
            })
        }
        
        if let participant = moment["nbParticipant"] as? Int {
            self.participantLabel.setTitle("Avec \(participant) participants", forState: UIControlState.Normal)
        }
        
        self.dateLabel.text = "Créé le \(moment.createdAt!)"
    }
}
