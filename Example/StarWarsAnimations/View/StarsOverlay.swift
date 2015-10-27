//
//  StarsOverlay.swift
//  StarWarsAnimations
//
//  Created by Artem Sidorenko on 9/11/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//

import UIKit

class StarsOverlay: UIView {

    override class func layerClass() -> AnyClass {
        return CAEmitterLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private var emitter: CAEmitterLayer {
        return layer as! CAEmitterLayer
    }
    
    private var particle: CAEmitterCell!
    
    func setup() {
        emitter.emitterMode = kCAEmitterLayerOutline
        emitter.emitterShape = kCAEmitterLayerCircle
        emitter.renderMode = kCAEmitterLayerOldestFirst
        emitter.preservesDepth = true
        
        particle = CAEmitterCell()
        
        particle.contents = UIImage(named: "spark")!.CGImage
        particle.birthRate = 10
        
        particle.lifetime = 50
        particle.lifetimeRange = 5
        
        particle.velocity = 20
        particle.velocityRange = 10
        
        particle.scale = 0.02
        particle.scaleRange = 0.1
        particle.scaleSpeed = 0.02
        
        emitter.emitterCells = [particle]
    }
    
    var emitterTimer: NSTimer?
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if self.window != nil {
            if emitterTimer == nil {
                emitterTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "randomizeEmitterPosition", userInfo: nil, repeats: true)
            }
        } else if emitterTimer != nil {
            emitterTimer?.invalidate()
            emitterTimer = nil
        }
    }
    
    func randomizeEmitterPosition() {
        let sizeWidth = max(bounds.width, bounds.height)
        let radius = CGFloat(arc4random()) % sizeWidth
        emitter.emitterSize = CGSize(width: radius, height: radius)
        particle.birthRate = 10 + sqrt(Float(radius))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emitter.emitterPosition = self.center
        emitter.emitterSize = self.bounds.size
    }
}
