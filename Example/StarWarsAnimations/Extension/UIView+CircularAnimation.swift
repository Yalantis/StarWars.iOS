//
//  UIView+CircularAnimation.swift
//  StarWarsAnimations
//
//  Created by Artem Sidorenko on 10/5/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//

import UIKit

extension UIView {
    
    func animateCircularWithDuration(duration: NSTimeInterval, center: CGPoint, @noescape animations: () -> Void, completion: ((Bool) -> Void)? = nil) {
        let snapshot = self.snapshotViewAfterScreenUpdates(false)
        snapshot.frame = self.bounds
        self.addSubview(snapshot)
        
        let center = self.convertPoint(center, toView: snapshot)
        let radius: CGFloat = {
            let x = max(center.x, frame.width - center.x)
            let y = max(center.y, frame.height - center.y)
            return sqrt(x * x + y * y)
        }()
        let animation = CircularRevealAnimator(layer: snapshot.layer, center: center, startRadius: 0, endRadius: radius, invert: true)
        animation.duration = duration
        animation.completion = {
            snapshot.removeFromSuperview()
            completion?(true)
        }
        animation.start()
        animations()
    }
}
