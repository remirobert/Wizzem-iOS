//
//  DrawTextView.swift
//  
//
//  Created by Remi Robert on 11/07/15.
//
//

import UIKit
import Masonry

class DrawTextView: UIView {

    private var textLabel: UILabel!
    
    var text: String! {
        didSet {
            textLabel.text = text
            sizeTextLabel()
        }
    }
    
    var fontSize: CGFloat! {
        didSet {
            textLabel.font = textLabel.font.fontWithSize(fontSize)
        }
    }
    
    init() {
        super.init(frame: CGRectZero)

        fontSize = 44
        backgroundColor = UIColor.clearColor()
        textLabel = UILabel()
        textLabel.textAlignment = NSTextAlignment.Center
        textLabel.text = "init text"
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFontOfSize(44)
        textLabel.textColor = UIColor.whiteColor()
        addSubview(textLabel)
        
        textLabel.mas_makeConstraints { (make: MASConstraintMaker!) -> Void in
            make.trailing.and().leading().equalTo()(self)
            make.centerY.equalTo()(self)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func sizeTextLabel() {
        let oldCenter = textLabel.center
        let styleText = NSMutableParagraphStyle()
        styleText.alignment = NSTextAlignment.Center
        let attributsText = [NSParagraphStyleAttributeName:styleText, NSFontAttributeName:UIFont.boldSystemFontOfSize(44)]
        let sizeTextLabel = (NSString(string: textLabel.text!)).boundingRectWithSize(superview!.frame.size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributsText, context: nil)
        textLabel.frame.size = sizeTextLabel.size
        textLabel.center = oldCenter
    }
}
