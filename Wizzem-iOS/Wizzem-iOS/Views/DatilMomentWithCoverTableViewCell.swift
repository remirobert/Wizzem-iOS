//
//  DatilMomentWithCoverTableViewCell.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 15/09/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class DatilMomentWithCoverTableViewCell: UITableViewCell, MomentCellProtocol {

    @IBOutlet var titleMoment: UILabel!
    @IBOutlet var dataMoment: UILabel!
    @IBOutlet var participantLabel: UILabel!
    @IBOutlet var wizzLabel: UILabel!
    @IBOutlet var cover: UIImageView!
    @IBOutlet var coverButton: UIButton!

}
