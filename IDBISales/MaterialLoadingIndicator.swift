//
//  MaterialLoadingIndicator.swift
//  AbhayCard-Swift
//
//  Created by Amit Dhadse on 09/05/17.
//  Copyright © 2017 Fast_Fingers. All rights reserved.
//

import UIKit

class MaterialLoadingIndicator: UIView {
    
    let MinStrokeLength: CGFloat = 0.05
    let MaxStrokeLength: CGFloat = 0.7
    let circleShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        initShapeLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       // fatalError("init(coder:) has not been implemented")
    }
    
    func initShapeLayer() {
        circleShapeLayer.actions = ["strokeEnd" : NSNull(),
                                    "strokeStart" : NSNull(),
                                    "transform" : NSNull(),
                                    "strokeColor" : NSNull()]
        circleShapeLayer.backgroundColor = UIColor.clear.cgColor
        circleShapeLayer.strokeColor     = UIColor.blue.cgColor
        circleShapeLayer.fillColor       = UIColor.clear.cgColor
        circleShapeLayer.lineWidth       = 4
        circleShapeLayer.lineCap         = kCALineCapRound
        circleShapeLayer.strokeStart     = 0
        circleShapeLayer.strokeEnd       = MinStrokeLength
        let center                       = CGPoint(x: bounds.width*0.5, y: bounds.height*0.5)
        circleShapeLayer.frame           = bounds
        circleShapeLayer.path            = UIBezierPath(arcCenter: center,
                                                        radius: center.x,
                                                        startAngle: 0,
                                                        endAngle: CGFloat(Double.pi*2),
                                                        clockwise: true).cgPath
        layer.addSublayer(circleShapeLayer)
    }
    
    func startAnimating() {
        if layer.animation(forKey: "rotation") == nil {
            startColorAnimation()
            startStrokeAnimation()
            startRotatingAnimation()
        }
    }
    
    private func startColorAnimation() {
        let color      = CAKeyframeAnimation(keyPath: "strokeColor")
        color.duration = 2.0
        color.values   = [UIColor(hex: 0x039D85, alpha: 1.0).cgColor,
                           UIColor(hex: 0xf7a873, alpha: 1.0).cgColor]
        
        color.calculationMode = kCAAnimationPaced
        color.repeatCount     = Float.infinity
        circleShapeLayer.add(color, forKey: "color")
        
    }
    
    private func startRotatingAnimation() {
        let rotation            =
            CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue        = Double.pi*2
        rotation.duration       = 1.8
        rotation.isCumulative     = true
        rotation.isAdditive       = true
        rotation.repeatCount    = Float.infinity
        layer.add(rotation, forKey: "rotation")
    }
    
    private func startStrokeAnimation() {
        let easeInOutSineTimingFunc = CAMediaTimingFunction(controlPoints: 0.39, 0.575, 0.565, 1.0)
        let progress: CGFloat     = MaxStrokeLength
        let endFromValue: CGFloat = circleShapeLayer.strokeEnd
        let endToValue: CGFloat   = endFromValue + progress
        let strokeEnd                   = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.fromValue             = endFromValue
        strokeEnd.toValue               = endToValue
        strokeEnd.duration              = 0.5
        strokeEnd.fillMode              = kCAFillModeForwards
        strokeEnd.timingFunction        = easeInOutSineTimingFunc
        strokeEnd.beginTime             = 0.1
        strokeEnd.isRemovedOnCompletion   = false
        let startFromValue: CGFloat     = circleShapeLayer.strokeStart
        let startToValue: CGFloat       = fabs(endToValue - MinStrokeLength)
        let strokeStart                 = CABasicAnimation(keyPath: "strokeStart")
        strokeStart.fromValue           = startFromValue
        strokeStart.toValue             = startToValue
        strokeStart.duration            = 0.4
        strokeStart.fillMode            = kCAFillModeForwards
        strokeStart.timingFunction      = easeInOutSineTimingFunc
        strokeStart.beginTime           = strokeEnd.beginTime + strokeEnd.duration + 0.2
        strokeStart.isRemovedOnCompletion = false
        let pathAnim                 = CAAnimationGroup()
        pathAnim.animations          = [strokeEnd, strokeStart]
        pathAnim.duration            = strokeStart.beginTime + strokeStart.duration
        pathAnim.fillMode            = kCAFillModeForwards
        pathAnim.isRemovedOnCompletion = false
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if self.circleShapeLayer.animation(forKey: "stroke") != nil {
                self.circleShapeLayer.transform = CATransform3DRotate(self.circleShapeLayer.transform, CGFloat(Double.pi*2) * progress, 0, 0, 1)
                self.circleShapeLayer.removeAnimation(forKey: "stroke")
                self.startStrokeAnimation()
            }
        }
        circleShapeLayer.add(pathAnim, forKey: "stroke")
        CATransaction.commit()
    }
    
    func stopAnimating() {
        circleShapeLayer.removeAllAnimations()
        layer.removeAllAnimations()
        circleShapeLayer.transform = CATransform3DIdentity
        layer.transform            = CATransform3DIdentity
    }
    
}

extension UIColor {
    
    convenience init(hex: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
}


