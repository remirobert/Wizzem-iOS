//
//  FeedEventCollectionViewCell.swift
//  
//
//  Created by Remi Robert on 20/06/15.
//
//

import UIKit

class FeedEventCollectionViewCell: UITableViewCell {
    
    @IBOutlet var titleWizzLabel: UILabel!
    @IBOutlet var authorUsernameLabel: UILabel!
    @IBOutlet var startEventLabel: UILabel!
    @IBOutlet var adresseEventLabel: UILabel!
    
    override func prepareForReuse() {
        titleWizzLabel.text = ""
        authorUsernameLabel.text = ""
        startEventLabel.text = ""
        adresseEventLabel.text = ""
    }
}
