//
//  UIView+CircularAnimation.swift
//  StarWarsAnimations
//
//  Created by Artem Sidorenko on 10/5/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//

import UIKit

extension UIView {
    
    open func animateCircular(withDuration duration: TimeInterval, center: CGPoint, revert: Bool = false, animations: () -> Void, completion: ((Bool) -> Void)? = nil) {
        let snapshot = snapshotView(afterScreenUpdates: false)!
        snapshot.frame = bounds
        self.addSubview(snapshot)
        
        let center = convert(center, to: snapshot)
        let radius: CGFloat = {
            let x = frame.width
            let y = frame.height
            return sqrt(x * x + y * y)
        }()
        var animation : CircularRevealAnimator
        if !revert {
            animation = CircularRevealAnimator(layer: snapshot.layer, center: center, startRadius: 0, endRadius: radius, invert: true)
        } else {
            animation = CircularRevealAnimator(layer: snapshot.layer, center: center, startRadius: radius, endRadius: 0, invert: false)
        }
        animation.duration = duration
        animation.completion = {
            snapshot.removeFromSuperview()
            completion?(true)
        }
        animation.start()
        animations()
    }
}
