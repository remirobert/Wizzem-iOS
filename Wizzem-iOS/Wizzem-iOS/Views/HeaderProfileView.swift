//
//  HeaderProfileView.swift
//  
//
//  Created by Remi Robert on 18/07/15.
//
//

import UIKit

class HeaderProfileView: UIView {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var starsNumberLabel: UILabel!
    @IBOutlet var buttonEditProfile: UIButton!
    
    
    override func awakeFromNib() {
        backgroundImageView.layer.masksToBounds = true
    }
}
