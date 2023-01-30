//
//  UIView+Skeleton.swift
//  Covid
//
//  Created by temptempest on 19.12.2022.
//

import UIKit

extension UIView {
    enum SkeletonPosition {
        case horizontal
        case vertical
        case horizontalWithAngle
    }
    
    private var skeletonLayerName: String {
        return "skeletonLayerName"
    }
    private var skeletonGradientName: String {
        return "skeletonGradientName"
    }
    
    func showSkeleton(duration: Double = 2,
                      backgroundColor: UIColor = UIColor(white: 210/255, alpha: 1.0),
                      highlightColor: UIColor = UIColor(white: 250/255, alpha: 1.0),
                      position: SkeletonPosition = .horizontal) {
        
        let screenBounds = UIScreen.main.bounds
        var angle: CGFloat = 0
        var animationKey = "transform.translation.x"
        var startPoint = CGPoint(x: 0.0, y: 0.5)
        var endPoint = CGPoint(x: 1.0, y: 0.5)
        var fromValue = -screenBounds.width
        var toValue = screenBounds.width
        
        switch position {
        case .horizontal: break
        case .vertical:
            animationKey = "transform.translation.y"
            startPoint = CGPoint(x: 0.5, y: 0)
            endPoint = CGPoint(x: 0.5, y: 1)
            fromValue = -screenBounds.height
            toValue = screenBounds.height
        case .horizontalWithAngle:
            angle = 45 * CGFloat.pi / 180
        }
        
        let skeletonLayer = CALayer()
        skeletonLayer.backgroundColor = backgroundColor.cgColor
        skeletonLayer.name = skeletonLayerName
        skeletonLayer.anchorPoint = .zero
        skeletonLayer.frame.size = screenBounds.size
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            backgroundColor.cgColor,
            highlightColor.cgColor,
            backgroundColor.cgColor
        ]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = screenBounds
        
        gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        gradientLayer.name = skeletonGradientName
        
        layer.mask = skeletonLayer
        layer.addSublayer(skeletonLayer)
        layer.addSublayer(gradientLayer)
        clipsToBounds = true
        
        let animation = CABasicAnimation(keyPath: animationKey)
        animation.duration = CFTimeInterval(duration)
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.repeatCount = .infinity
        animation.autoreverses = false
        animation.fillMode = .forwards
        gradientLayer.add(animation, forKey: "AwesomeAnimation")
    }
    
    func hideSkeleton() {
        layer.sublayers?.removeAll {
            $0.name == skeletonLayerName || $0.name == skeletonGradientName
        }
    }
}
