//
//  Created by Artem Sidorenko on 9/14/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at https://github.com/Yalantis/StarWars.iOS
//

import UIKit
import GLKit

public class StarWarsGLAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var duration: NSTimeInterval = 2
    public var spriteWidth: CGFloat = 8
    
    
    private var sprites: [BlowSprite] = []
    private var glContext: EAGLContext!
    private var texture: ViewTexture!
    private var effect: GLKBaseEffect!
    private var fromView: UIView!
    private var glView: GLKView!
    private var displayLink: CADisplayLink!
    private var lastUpdateTime: NSTimeInterval?
    private var startTransitionTime: NSTimeInterval!
    private var transitionContext: UIViewControllerContextTransitioning!
    private var render: BlowSpriteRender!
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()!
        let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view
        let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!.view
        
        containerView.addSubview(toView)
        containerView.sendSubviewToBack(toView)
        
        func randomFloatBetween(smallNumber: CGFloat, and bigNumber: CGFloat) -> Float {
            let diff = bigNumber - smallNumber
            return Float(CGFloat(arc4random()) / 100.0 % diff + smallNumber)
        }
        
        self.glContext = EAGLContext(API: .OpenGLES2)
        EAGLContext.setCurrentContext(glContext)
        
        glView = GLKView(frame: fromView.frame, context: glContext)
        glView.enableSetNeedsDisplay = true
        glView.delegate = self
        glView.opaque = false
        containerView.addSubview(glView)

        texture = ViewTexture()
        texture.setupOpenGL()
        texture.renderView(fromView)
        
        effect = GLKBaseEffect()
        let projectionMatrix = GLKMatrix4MakeOrtho(0, Float(texture.width), 0, Float(texture.height), -1, 1)
        effect.transform.projectionMatrix = projectionMatrix
        
        render = BlowSpriteRender(texture: texture, effect: effect)
        
        let size = CGSize(width: CGFloat(texture.width), height: CGFloat(texture.height))
        
        let scale = UIScreen.mainScreen().scale
        let width = spriteWidth * scale
        let height = width
        
        for x in CGFloat(0).stride(through: size.width, by: width) {
            for y in CGFloat(0).stride(through: size.height, by: height) {
                let region = CGRect(x: x, y: y, width: width, height: height)
                var sprite = BlowSprite()
                sprite.slice(region, textureSize: size)
                sprite.moveVelocity = Vector2(x: randomFloatBetween(-100, and: 100), y: randomFloatBetween(-CGFloat(texture.height)*1.3/CGFloat(duration), and: -CGFloat(texture.height)/CGFloat(duration)))

                sprites.append(sprite)
            }
        }
        fromView.removeFromSuperview()
        self.transitionContext = transitionContext
        
        displayLink = CADisplayLink(target: self, selector: "displayLinkTick:")
        displayLink.paused = false
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        
        self.startTransitionTime = NSDate.timeIntervalSinceReferenceDate()        
    }
    
    public func animationEnded(transitionCompleted: Bool) {
        self.displayLink.invalidate()
        self.displayLink = nil
    }
    
    func displayLinkTick(displayLink: CADisplayLink) {
        if let lastUpdateTime = lastUpdateTime {
            let timeSinceLastUpdate = NSDate.timeIntervalSinceReferenceDate() - lastUpdateTime
            self.lastUpdateTime = NSDate.timeIntervalSinceReferenceDate()
            for index in 0..<sprites.count {
                sprites[index].update(timeSinceLastUpdate)
            }
        } else {
            self.lastUpdateTime = NSDate.timeIntervalSinceReferenceDate()
        }
        self.glView.setNeedsDisplay()
        if NSDate.timeIntervalSinceReferenceDate() - self.startTransitionTime > self.duration {
            self.transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}

extension StarWarsGLAnimator: GLKViewDelegate {
    
    public func glkView(view: GLKView, drawInRect rect: CGRect) {
        glClearColor(0, 0, 0, 0)
        glClear(UInt32(GL_COLOR_BUFFER_BIT))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        glEnable(GLenum(GL_BLEND))
        
        render.render(self.sprites)
    }
}
