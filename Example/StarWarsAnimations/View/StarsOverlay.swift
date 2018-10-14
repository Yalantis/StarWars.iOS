//
//  StarsOverlay.swift
//  StarWarsAnimations
//
//  Created by Artem Sidorenko on 9/11/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//

import UIKit

class StarsOverlay: UIView {

    override class var layerClass : AnyClass {
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
    
    fileprivate var emitter: CAEmitterLayer {
        return layer as! CAEmitterLayer
    }
    
    fileprivate var particle: CAEmitterCell!
    
    func setup() {
        emitter.emitterMode = .outline
        emitter.emitterShape = .circle
        emitter.renderMode = .oldestFirst
        emitter.preservesDepth = true
        
        particle = CAEmitterCell()
        
        particle.contents = UIImage(named: "spark")!.cgImage
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
    
    var emitterTimer: Timer?
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if self.window != nil {
            if emitterTimer == nil {
                emitterTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(StarsOverlay.randomizeEmitterPosition), userInfo: nil, repeats: true)
            }
        } else if emitterTimer != nil {
            emitterTimer?.invalidate()
            emitterTimer = nil
        }
    }
    
    @objc func randomizeEmitterPosition() {
        let sizeWidth = max(bounds.width, bounds.height)
        let radius = CGFloat(arc4random()).truncatingRemainder(dividingBy: sizeWidth)
        emitter.emitterSize = CGSize(width: radius, height: radius)
        particle.birthRate = 10 + sqrt(Float(radius))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emitter.emitterPosition = self.center
        emitter.emitterSize = self.bounds.size
    }
}
