//
//  SearchProfileTableViewCell.swift
//  
//
//  Created by Remi Robert on 23/06/15.
//
//

import UIKit

class SearchProfileTableViewCell: UITableViewCell {

    @IBOutlet var profileImageview: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var followUnfollowLabel: UIButton!
    
    var blockCompletion: (() -> Void)!
    
    func clickFollowUnfollowButton() {
        blockCompletion()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        followUnfollowLabel.addTarget(self, action: "clickFollowUnfollowButton", forControlEvents: UIControlEvents.TouchUpInside)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
