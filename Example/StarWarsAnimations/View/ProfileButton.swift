//
//  ProfileButton.swift
//  StarWarsAnimations
//
//  Created by Artem Sidorenko on 10/5/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//

import UIKit

private let ButtonPadding: CGFloat = 50

@IBDesignable class ProfileButton: UIButton {
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + ButtonPadding, height: size.height)
    }

    func animateTouchUpInside(completion: @escaping () -> Void) {
        isUserInteractionEnabled = false
        layer.masksToBounds = true
        
        let fillLayer = CALayer()
        fillLayer.backgroundColor = layer.borderColor
        fillLayer.frame = layer.bounds
        layer.insertSublayer(fillLayer, at: 0)
        
        let center = CGPoint(x: fillLayer.bounds.midX, y: fillLayer.bounds.midY)
        let radius: CGFloat = max(frame.width / 2 , frame.height / 2)
  
        let circularAnimation = CircularRevealAnimator(layer: fillLayer, center: center, startRadius: 0, endRadius: radius)
        circularAnimation.duration = 0.2
        circularAnimation.completion = {
            fillLayer.opacity = 0
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 1
            opacityAnimation.toValue = 0
            opacityAnimation.duration = 0.2
            opacityAnimation.delegate = AnimationDelegate {
                fillLayer.removeFromSuperlayer()
                self.isUserInteractionEnabled = true
                completion()
            }
            fillLayer.add(opacityAnimation, forKey: "opacity")
        }
        circularAnimation.start()
    }
}
