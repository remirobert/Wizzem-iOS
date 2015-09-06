//
//  DetailMomentCollectionViewCell.swift
//  
//
//  Created by Remi Robert on 30/07/15.
//
//

import UIKit

class DetailMomentCollectionViewCell: UICollectionViewCell {

    @IBOutlet var titleEvent: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var numberWizzLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var participantLabel: UIButton!
    @IBOutlet var addMediaButton: UIButton!
    @IBOutlet var settingButton: UIButton!
    @IBOutlet var downbutton: UIButton!
    @IBOutlet var inviteLink: UIButton!
    @IBOutlet var buttonDisplayDescription: UIButton!
    @IBOutlet var privacyEvent: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func loadDetailMoment(moment: PFObject) {
        titleEvent.text = nil
        descriptionLabel.text = nil
        authorLabel.text = nil
        participantLabel.setTitle("0", forState: UIControlState.Normal)
        numberWizzLabel.text = nil
        dateLabel.text = nil
        
        moment.fetchIfNeededInBackgroundWithBlock { (moment: PFObject?, _) -> Void in
            if let moment = moment {
                
                if let privacy = moment["public"] as? Bool {
                    if privacy {
                        self.privacyEvent.image = UIImage(named: "LockOpen")
                    }
                    else {
                        self.privacyEvent.image = UIImage(named: "LockLock")
                    }
                }
                
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
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.authorLabel.text = username
                                });
                            }
                        }
                    })
                }
                if let participant = moment["nbParticipant"] as? Int {
                    self.participantLabel.setTitle("Avec \(participant) participants", forState: UIControlState.Normal)
                }
                if let nbWizz = moment["nbMedia"] as? Int {
                    self.numberWizzLabel.text = "\(nbWizz)"
                }
                
                if let isFacebookEvent = moment["facebook"] as? Bool {
                    if !isFacebookEvent {
                        if let dateMoment = moment.createdAt {
                            let formatString = dateMoment.formattedDateWithFormat("EEE, MMM d")
                            let formatStringHour = dateMoment.formattedDateWithFormat("h:mm")
                            self.dateLabel.text = "Créé le \(formatString) à \(formatStringHour)"
                        }
                    }
                    else {
                        if let dateMoment = moment["start"] as? NSDate {
                            let formatString = dateMoment.formattedDateWithFormat("EEE, MMM d")
                            let formatStringHour = dateMoment.formattedDateWithFormat("h:mm")
                            self.dateLabel.text = "Commence le \(formatString) à \(formatStringHour)"
                        }
                    }
                }
            }
        }
    }
}
