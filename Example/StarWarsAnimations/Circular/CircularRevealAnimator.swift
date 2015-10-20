//
//  Copyright © 2014 Yalantis
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//

import QuartzCore

private func SquareAroundCircle(center: CGPoint, radius: CGFloat) -> CGRect {
    assert(0 <= radius, "radius must be a positive value")
    return CGRectInset(CGRect(origin: center, size: CGSizeZero), -radius, -radius)
}

class CircularRevealAnimator {
    var completion: () -> Void = {}

    private let layer: CALayer
    private let mask: CAShapeLayer
    private let animation: CABasicAnimation

    var duration: CFTimeInterval {
        get { return animation.duration }
        set(value) { animation.duration = value }
    }

    var timingFunction: CAMediaTimingFunction! {
        get { return animation.timingFunction }
        set(value) { animation.timingFunction = value }
    }

    init(layer: CALayer, center: CGPoint, startRadius: CGFloat, endRadius: CGFloat, invert: Bool = false) {
        let startCirclePath = CGPathCreateWithEllipseInRect(SquareAroundCircle(center, radius: startRadius), UnsafePointer())
        let endCirclePath = CGPathCreateWithEllipseInRect(SquareAroundCircle(center, radius: endRadius), UnsafePointer())
        
        var startPath = startCirclePath, endPath = endCirclePath
        if invert {
            var path = CGPathCreateMutable()
            CGPathAddRect(path, nil, layer.bounds)
            CGPathAddPath(path, nil, startCirclePath)
            startPath = path
            path = CGPathCreateMutable()
            CGPathAddRect(path, nil, layer.bounds)
            CGPathAddPath(path, nil, endCirclePath)
            endPath = path
        }
        self.layer = layer

        mask = CAShapeLayer()
        mask.path = endPath
        mask.fillRule = kCAFillRuleEvenOdd

        animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = startPath
        animation.toValue = endPath
        animation.delegate = AnimationDelegate {
            layer.mask = nil
            self.completion()
            self.animation.delegate = nil
        }
    }

    func start() {
        layer.mask = mask
        mask.frame = layer.bounds
        mask.addAnimation(animation, forKey: "reveal")
    }
}