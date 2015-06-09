//
//  LoginButton.swift
//  Wizzem
//
//  Created by Remi Robert on 09/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class LoginButton: UIButton {

    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            self.layer.borderColor = borderColor.CGColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        self.layer.masksToBounds = true
    }

}
