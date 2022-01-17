//
//  UIView+Extensions.swift
//  Series
//
//  Created by Jesus Cueto on 1/16/22.
//

import UIKit

extension UIView {
    func startAnimating() {
    let gradientLayer = CAGradientLayer()
    /* Allocate the frame of the gradient layer as the view's bounds, since the layer will sit on top of the view. */
      
      gradientLayer.frame = self.bounds
    /* To make the gradient appear moving from left to right, we are providing it the appropriate start and end points.
    Refer to the diagram above to understand why we chose the following points.
    */
      gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
      gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
      gradientLayer.colors = [UIColor(white: 0.85, alpha: 1.0).cgColor, UIColor(white: 0.95, alpha: 1.0).cgColor, UIColor(white: 0.85, alpha: 1.0).cgColor]
      gradientLayer.locations = [0.0, 0.5, 1.0]
    /* Adding the gradient layer on to the view */
      self.layer.addSublayer(gradientLayer)
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 0.9
        gradientLayer.add(animation, forKey: animation.keyPath)
    }
    
    func stopAnimation() {
        self.layer.removeAllAnimations()
        let gradientLayer = self.layer.sublayers?.filter {$0.isKind(of: CAGradientLayer.self) }.first
        gradientLayer?.removeFromSuperlayer()
    }
}
