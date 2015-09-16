//
//  DimBackgroundView.swift
//  Wizzem-iOS
//
//  Created by Remi Robert on 16/09/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class DimBackgroundView: UIView {
    
    class func dimBackground() -> UIView {
        let view = UIView(frame: UIScreen.mainScreen().bounds)
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.65)
        return view
    }
}
