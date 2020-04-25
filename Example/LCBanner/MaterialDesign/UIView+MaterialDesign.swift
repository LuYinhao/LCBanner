//
//  UIView+MaterialDesign.swift
//  LCBanner_Example
//
//  Created by 卢荫豪 on 2020/4/25.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
public let UIViewMaterialDesignTransitionDurationCoeff = 0.65

extension UIView{
    /**
     一些注意事项:
     -原始点在fromView坐标系
     -过渡使用fromView。父视图作为containerView
     - transition set to view frame = fromView frame
     - transtion使用持续时间* 0.65的形状转换和(持续时间-持续时间* 0.65)淡出动画，如果你想改变它
     */
    private func mdInflateTransitionFromView(fromView:UIView,toView:UIView,originalPoint:CGPoint,duration:TimeInterval,completion:@escaping()->()){
        
        if fromView.superview != nil {
            let containerView:UIView = fromView.superview!
            
            let convertedPoint:CGPoint = fromView.convert(originalPoint, from: fromView)
            containerView.layer.masksToBounds = true
            
            containerView.mdAnimateAtPoint(point: convertedPoint, backgroundColor: toView.backgroundColor!, duration: duration*UIViewMaterialDesignTransitionDurationCoeff, inflating: true, zTopPosition: true, shapeLayer: nil, completion: {
                toView.alpha = 0.0
                // TODO: transform property could be not identity
                toView.frame = fromView.frame
                containerView.addSubview(toView)
                fromView.removeFromSuperview()
                let animationDuration:TimeInterval =  (duration - duration * UIViewMaterialDesignTransitionDurationCoeff)
                UIView.animate(withDuration: animationDuration, animations: {
                    toView.alpha = 1.0
                }, completion: {(finished) in
                    completion()
                })
                
            })
            
        }else{
            completion()
        }
    }
    private func mdDeflateTransitionFromView(fromView:UIView,toView:UIView,originalPoint:CGPoint,duration:TimeInterval,completion:@escaping()->()){
        
        if fromView.superview != nil {
            // insert destination view
            let containerView:UIView = fromView.superview!
            containerView.insertSubview(toView, belowSubview: fromView)
            toView.frame = fromView.frame
            // convert point into container view coordinate system
            let convertedPoint:CGPoint = toView.convert(originalPoint, from: fromView)
            // insert layer
            let layer:CAShapeLayer = toView.mdShapeLayerForAnimationAtPoint(point: convertedPoint)
            layer.fillColor = fromView.backgroundColor?.cgColor
            toView.layer.addSublayer(layer)
            toView.layer.masksToBounds = true
            // hide fromView
            let animationDuration:TimeInterval = (duration - duration * UIViewMaterialDesignTransitionDurationCoeff)
            UIView.animate(withDuration: animationDuration, animations: {
                fromView.alpha = 0.0
            }, completion: {(finished)in
                toView.mdAnimateAtPoint(point: convertedPoint, backgroundColor:fromView.backgroundColor!, duration: duration*UIViewMaterialDesignTransitionDurationCoeff, inflating: false, zTopPosition: true, shapeLayer: layer, completion: {
                    completion()
                })
            })
            
        }else{
            completion()
        }
    }
    
    ///这些方法使用形状动画使视图的背景颜色产生动画效果。
    func mdInflateAnimatedFromPoint(point:CGPoint,backgroundColor:UIColor,duration:TimeInterval,completion: @escaping()->()){
        self.mdAnimateAtPoint(point: point, backgroundColor: backgroundColor, duration: duration, inflating: true, zTopPosition: false, shapeLayer: nil, completion: completion)
        
    }
    func mdDeflateAnimatedToPoint(point:CGPoint,backgroundColor:UIColor,duration:TimeInterval,completion:@escaping ()->()){
        self.mdAnimateAtPoint(point:point , backgroundColor: backgroundColor, duration: duration, inflating: false, zTopPosition: false, shapeLayer: nil, completion: completion)
        
    }
    
    
    //#pragma mark - helpers
    private func mdShapeDiameterForPoint(point:CGPoint) -> CGFloat{
        let cornerPoints:[CGPoint] = [CGPoint.init(x: 0.0, y: 0.0),
                                      CGPoint.init(x: 0.0, y: self.bounds.size.height),CGPoint.init(x: self.bounds.size.width, y: self.bounds.size.height), CGPoint.init(x: self.bounds.size.width, y: 0.0) ]
        var radius:CGFloat = 0.0
        for p:CGPoint in cornerPoints {
            
            let d = sqrt( pow(p.x - point.x, 2.0) + pow(p.y - point.y, 2.0) );
            if (d > radius) {
                radius = d
            }
        }
        return radius * 2.0
    }
    
    private func mdShapeLayerForAnimationAtPoint(point:CGPoint) -> CAShapeLayer {
        let shapeLayer:CAShapeLayer = CAShapeLayer.init()
        let diameter:CGFloat  = self.mdShapeDiameterForPoint(point: point)
        shapeLayer.frame = CGRect.init(x: floor(point.x - diameter * 0.5), y: floor(point.y - diameter * 0.5), width: diameter, height: diameter)
        shapeLayer.path = UIBezierPath.init(rect: CGRect.init(x: 0.0, y: 0.0, width: diameter, height: diameter)).cgPath
        return shapeLayer
    }
    private func shapeAnimationWithTimingFunction(timingFunction:CAMediaTimingFunction,scale:CGFloat,inflating:Bool) -> CABasicAnimation {
        let animation:CABasicAnimation = CABasicAnimation.init(keyPath: "transform")
        if inflating {
            
            animation.toValue = NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))
            animation.fromValue = NSValue.init(caTransform3D:CATransform3DMakeScale(scale, scale, 1.0))
        }else{
            animation.toValue = NSValue.init(caTransform3D: CATransform3DMakeScale(scale, scale, 1.0))
            animation.fromValue = NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))
        }
        animation.timingFunction = timingFunction
        animation.isRemovedOnCompletion = true
        return animation
    }
    //#pragma mark - animation
    private func mdAnimateAtPoint(point:CGPoint,backgroundColor:UIColor,duration:TimeInterval,inflating:Bool,zTopPosition:Bool,shapeLayer:CAShapeLayer?,completion: @escaping ()->()){
        var nshapeLayer = shapeLayer
        if shapeLayer == nil{
            nshapeLayer = self.mdShapeLayerForAnimationAtPoint(point: point)
            self.layer.masksToBounds = true
            if zTopPosition {
                self.layer.addSublayer(nshapeLayer!)
            }else{
                self.layer.insertSublayer(nshapeLayer!, at: 0)
            }
            if inflating == false {
                nshapeLayer!.fillColor = self.backgroundColor?.cgColor
                self.backgroundColor = backgroundColor
            }else{
                nshapeLayer!.fillColor = backgroundColor.cgColor
            }
        }
        // animate
        let scale = 1.0/nshapeLayer!.frame.size.width
        let timingFunctionName:String = kCAMediaTimingFunctionDefault//inflating ? kCAMediaTimingFunctionDefault : kCAMediaTimingFunctionDefault;
        let animation:CABasicAnimation = self.shapeAnimationWithTimingFunction(timingFunction: CAMediaTimingFunction.init(name: timingFunctionName), scale: scale, inflating: inflating)
        animation.duration = duration
        nshapeLayer?.transform =  animation.toValue as! CATransform3D
        CATransaction.begin()
        CATransaction.setCompletionBlock{
            if inflating{
                self.backgroundColor = backgroundColor
            }
            nshapeLayer?.removeFromSuperlayer()
            completion()
        }
        nshapeLayer?.add(animation, forKey: "shapeBackgroundAnimation")
        CATransaction.commit()
        
    }
}

