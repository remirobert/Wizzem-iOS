//
//  MomentTableViewCell.swift
//  
//
//  Created by Remi Robert on 18/07/15.
//
//

import UIKit

class MomentTableViewCell: UITableViewCell {

    @IBOutlet var titleMomentLabel: UILabel!
    @IBOutlet var participantLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
