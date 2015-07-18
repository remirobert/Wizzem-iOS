//
//  LastWizzMomentTableViewCell.swift
//  
//
//  Created by Remi Robert on 09/07/15.
//
//

import UIKit

class LastWizzMomentTableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var numberMedia: UILabel!
    @IBOutlet var numberUsers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        title.text = nil
        numberMedia.text = nil
        numberUsers.text = nil
    }
}
