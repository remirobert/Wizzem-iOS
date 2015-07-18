//
//  DrawView.swift
//  
//
//  Created by Remi Robert on 11/07/15.
//
//

import UIKit
import Masonry

class DrawView: UIView, TextEditViewDelegate {

    private var textEditView: TextEditView!
    private var drawTextView: DrawTextView!
    
    private var initialCenterDrawTextView: CGPoint!
    private var initialRotationTransform: CGAffineTransform!
    private var initialReferenceRotationTransform: CGAffineTransform!
    
    private var activieGestureRecognizer = NSMutableSet()
    private var activeRotationGesture: UIRotationGestureRecognizer?
    private var activePinchGesture: UIPinchGestureRecognizer?
    
    private lazy var tapRecognizer: UITapGestureRecognizer! = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        tapRecognizer.delegate = self
        return tapRecognizer
    }()
    
    private lazy var panRecognizer: UIPanGestureRecognizer! = {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        panRecognizer.delegate = self
        return panRecognizer
    }()
    
    private lazy var rotateRecognizer: UIRotationGestureRecognizer! = {
        let rotateRecognizer = UIRotationGestureRecognizer(target: self, action: "handlePinchGesture:")
        rotateRecognizer.delegate = self
        return rotateRecognizer
    }()

    private lazy var zoomRecognizer: UIPinchGestureRecognizer! = {
        let zoomRecognizer = UIPinchGestureRecognizer(target: self, action: "handlePinchGesture:")
        zoomRecognizer.delegate = self
        return zoomRecognizer
    }()
    
    private func setup() {
        self.layer.masksToBounds = true
        drawTextView = DrawTextView()
        addSubview(drawTextView)
        drawTextView.mas_makeConstraints { (make: MASConstraintMaker!) -> Void in
            make.edges.equalTo()(self)
        }

        textEditView = TextEditView()
        textEditView.delegate = self

        addSubview(textEditView)
        textEditView.mas_makeConstraints { (make: MASConstraintMaker!) -> Void in
            make.edges.equalTo()(self)
        }
        
        addGestureRecognizer(tapRecognizer)
        addGestureRecognizer(panRecognizer)
        addGestureRecognizer(rotateRecognizer)
        addGestureRecognizer(zoomRecognizer)
        
        initialReferenceRotationTransform = CGAffineTransformIdentity
    }
    
    init() {
        super.init(frame: CGRectZero)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func textEditViewFinishedEditing(text: String) {
        textEditView.hidden = true
        drawTextView.text = text
    }
}

extension DrawView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleTapGesture(recognizer: UITapGestureRecognizer) {
        textEditView.isEditing = true
        textEditView.hidden = false
    }
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self)
        switch recognizer.state {
        case .Began, .Ended, .Failed, .Cancelled:
            initialCenterDrawTextView = drawTextView.center
        case .Changed:
            drawTextView.center = CGPointMake(initialCenterDrawTextView.x + translation.x,
                initialCenterDrawTextView.y + translation.y)
        default: return
        }
    }
    
    func handlePinchGesture(recognizer: UIGestureRecognizer) {
        var transform = initialRotationTransform
        
        switch recognizer.state {
        case .Began:
            if activieGestureRecognizer.count == 0 {
                initialRotationTransform = drawTextView.transform
            }
            activieGestureRecognizer.addObject(recognizer)
            break
            
        case .Changed:
            for currentRecognizer in activieGestureRecognizer {
                transform = applyRecogniser(currentRecognizer as? UIGestureRecognizer, currentTransform: transform)
            }
            drawTextView.transform = transform
            break
            
        case .Ended, .Failed, .Cancelled:
            initialRotationTransform = applyRecogniser(recognizer, currentTransform: initialRotationTransform)
            activieGestureRecognizer.removeObject(recognizer)
        default: return
        }

    }
    
    private func applyRecogniser(recognizer: UIGestureRecognizer?, currentTransform: CGAffineTransform) -> CGAffineTransform {
        if let recognizer = recognizer {
            if recognizer is UIRotationGestureRecognizer {
                return CGAffineTransformRotate(currentTransform, (recognizer as! UIRotationGestureRecognizer).rotation)
            }
            if recognizer is UIPinchGestureRecognizer {
                let scale = (recognizer as! UIPinchGestureRecognizer).scale
                return CGAffineTransformScale(currentTransform, scale, scale)
            }
        }
        return currentTransform
    }
}

extension DrawView {
    
    func background() -> UIImage {
        let size = UIScreen.mainScreen().bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        UIColor.whiteColor().setFill()
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, size.width, size.height))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return colorImage
    }
    
    func currentView() -> UIImage {
        let size = UIScreen.mainScreen().bounds.size
        let scale = size.width / CGRectGetWidth(self.bounds)
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
        
        layer.renderInContext(UIGraphicsGetCurrentContext())
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return img
    }
    
    func drawTextOnImage(image: UIImage) -> UIImage? {
        let size = image.size
        let scale = image.size.width / CGRectGetWidth(self.bounds)
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 1.5)
        
        image.drawInRect(CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)))
        layer.renderInContext(UIGraphicsGetCurrentContext())



        let drawnImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return UIImage(CGImage: drawnImage.CGImage, scale: 1, orientation: drawnImage.imageOrientation)
    }
}
