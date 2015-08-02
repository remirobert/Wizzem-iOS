//
//  MediaTextView.swift
//  
//
//  Created by Remi Robert on 10/07/15.
//
//

import UIKit

class MediaTextView: UITextView, UITextViewDelegate {

    var oldPosition: CGFloat = UIScreen.mainScreen().bounds.size.height / 2
    var previousY: CGFloat!
    var isEditing = false
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        println("add text {\(text)}")
        if text == "\n" {
            self.superview?.endEditing(true)
            return false
        }
        if count(self.text) + count(text) >= 64 {
            return false
        }
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.frame.origin.y = self.oldPosition
            })
        })
        return true
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        oldPosition = frame.origin.y
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.frame.origin.y = 100
            })
        })
        return true
    }
    
    func handleGesture(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Began:
            self.previousY = self.center.y
        case .Changed:
            let translation = gesture.translationInView(self)
            var newPosition = self.previousY + translation.y
            if  newPosition < 150 {
                newPosition = 150
            }
            else if newPosition > UIScreen.mainScreen().bounds.size.height - 150 {
                newPosition = UIScreen.mainScreen().bounds.size.height - 150
            }
            self.center = CGPointMake(self.center.x, newPosition)
            
        case .Ended, .Cancelled, .Failed:
            self.previousY = self.center.y
        default: return
        }
    }
    
    func tapHandle(tapRecognizer: UITapGestureRecognizer) {
        if !isEditing {
            self.becomeFirstResponder()
            isEditing = true
        }
        else {
            self.resignFirstResponder()
            isEditing = false
        }
    }
    
    override func awakeFromNib() {
        self.delegate = self
        let gesture = UIPanGestureRecognizer(target: self, action: "handleGesture:")
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapHandle:")
        self.addGestureRecognizer(gesture)
        //self.addGestureRecognizer(tapGesture)
    }

}
