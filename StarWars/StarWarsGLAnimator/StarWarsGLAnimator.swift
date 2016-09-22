//
//  Created by Artem Sidorenko on 9/14/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at https://github.com/Yalantis/StarWars.iOS
//

import UIKit
import GLKit

open class StarWarsGLAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    open var duration: TimeInterval = 2
    open var spriteWidth: CGFloat = 8
    
    fileprivate var sprites: [Sprite] = []
    fileprivate var glContext: EAGLContext!
    fileprivate var effect: GLKBaseEffect!
    fileprivate var glView: GLKView!
    fileprivate var displayLink: CADisplayLink!
    fileprivate var lastUpdateTime: TimeInterval?
    fileprivate var startTransitionTime: TimeInterval!
    fileprivate var transitionContext: UIViewControllerContextTransitioning!
    fileprivate var render: SpriteRender!
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view
        
        containerView.addSubview(toView!)
        containerView.sendSubview(toBack: toView!)
        
        func randomFloatBetween(_ smallNumber: CGFloat, and bigNumber: CGFloat) -> Float {
            let diff = bigNumber - smallNumber
            return Float((CGFloat(arc4random()) / 100.0).truncatingRemainder(dividingBy: diff) + smallNumber)
        }
        
        self.glContext = EAGLContext(api: .openGLES2)
        EAGLContext.setCurrent(glContext)
        
        glView = GLKView(frame: (fromView?.frame)!, context: glContext)
        glView.enableSetNeedsDisplay = true
        glView.delegate = self
        glView.isOpaque = false
        containerView.addSubview(glView)

        let texture = ViewTexture()
        texture.setupOpenGL()
        texture.render(view: fromView!)
        
        effect = GLKBaseEffect()
        let projectionMatrix = GLKMatrix4MakeOrtho(0, Float(texture.width), 0, Float(texture.height), -1, 1)
        effect.transform.projectionMatrix = projectionMatrix
        
        render = SpriteRender(texture: texture, effect: effect)
        
        let size = CGSize(width: CGFloat(texture.width), height: CGFloat(texture.height))
        
        let scale = UIScreen.main.scale
        let width = spriteWidth * scale
        let height = width
        
        for x in stride(from: CGFloat(0), through: size.width, by: width) {
            for y in stride(from: CGFloat(0), through: size.height, by: height) {
                let region = CGRect(x: x, y: y, width: width, height: height)
                var sprite = Sprite()
                sprite.slice(region, textureSize: size)
                sprite.moveVelocity = Vector2(x: randomFloatBetween(-100, and: 100), y: randomFloatBetween(-CGFloat(texture.height)*1.3/CGFloat(duration), and: -CGFloat(texture.height)/CGFloat(duration)))

                sprites.append(sprite)
            }
        }
        fromView?.removeFromSuperview()
        self.transitionContext = transitionContext
        
        displayLink = CADisplayLink(target: self, selector: #selector(StarWarsGLAnimator.displayLinkTick(_:)))
        displayLink.isPaused = false
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        
        self.startTransitionTime = Date.timeIntervalSinceReferenceDate        
    }
    
    open func animationEnded(_ transitionCompleted: Bool) {
        displayLink.invalidate()
        displayLink = nil
    }
    
    func displayLinkTick(_ displayLink: CADisplayLink) {
        if let lastUpdateTime = lastUpdateTime {
            let timeSinceLastUpdate = Date.timeIntervalSinceReferenceDate - lastUpdateTime
            self.lastUpdateTime = Date.timeIntervalSinceReferenceDate
            for index in 0..<sprites.count {
                sprites[index].update(timeSinceLastUpdate)
            }
        } else {
            lastUpdateTime = Date.timeIntervalSinceReferenceDate
        }
        glView.setNeedsDisplay()
        if Date.timeIntervalSinceReferenceDate - startTransitionTime > duration {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

extension StarWarsGLAnimator: GLKViewDelegate {
    
    public func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0, 0, 0, 0)
        glClear(UInt32(GL_COLOR_BUFFER_BIT))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        glEnable(GLenum(GL_BLEND))
        
        render.render(self.sprites)
    }
}
