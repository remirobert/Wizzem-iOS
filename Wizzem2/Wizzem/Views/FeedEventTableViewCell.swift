//
//  FeedEventTableViewCell.swift
//  
//
//  Created by Remi Robert on 10/07/15.
//
//

import UIKit

class FeedEventTableViewCell: UITableViewCell {
   
    @IBOutlet var titleWizz: UILabel!
    @IBOutlet var participantsWizz: UILabel!

    @IBOutlet var previewImageView: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
