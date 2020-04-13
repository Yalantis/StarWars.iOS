//
//  Created by Artem Sidorenko on 9/11/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at https://github.com/Yalantis/StarWars.iOS
//

import UIKit

open class StarWarsUIDynamicAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    open var duration: TimeInterval = 2
    open var spriteWidth: CGFloat = 20

    var transitionContext: UIViewControllerContextTransitioning!

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    var animator: UIDynamicAnimator!
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view
        
        containerView.addSubview(toView!)
        containerView.sendSubview(toBack: toView!)
        
        let size = fromView!.frame.size
        
        func randomFloatBetween(_ smallNumber: CGFloat, and bigNumber: CGFloat) -> CGFloat {
            let diff = bigNumber - smallNumber
            return (CGFloat(arc4random()) / 100.0).truncatingRemainder(dividingBy: diff) + smallNumber
        }
        
        // snapshot the from view, this makes subsequent snaphots more performant
        let fromViewSnapshot = fromView?.snapshotView(afterScreenUpdates: false)

        let width = spriteWidth
        let height = width
        
        animator = UIDynamicAnimator(referenceView: containerView)
        
        var snapshots: [UIView] = []
        for x in stride(from: CGFloat(0), through: size.width, by: width) {
            for y in stride(from: CGFloat(0), through: size.height, by: height) {
                let snapshotRegion = CGRect(x: x, y: y, width: width, height: height)
                
                let snapshot = fromViewSnapshot!.resizableSnapshotView(from: snapshotRegion, afterScreenUpdates: false, withCapInsets: .zero)!
                
                containerView.addSubview(snapshot)
                snapshot.frame = snapshotRegion
                snapshots.append(snapshot)
                
                let push = UIPushBehavior(items: [snapshot], mode: .instantaneous)
                push.pushDirection = CGVector(dx: randomFloatBetween(-0.15 , and: 0.15), dy: randomFloatBetween(-0.15 , and: 0))
                push.active = true
                animator.addBehavior(push)
            }
        }
        let gravity = UIGravityBehavior(items: snapshots)
        animator.addBehavior(gravity)

        print(snapshots.count)
        
        fromView?.removeFromSuperview()
        
        Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(StarWarsUIDynamicAnimator.completeTransition), userInfo: nil, repeats: false)
        self.transitionContext = transitionContext
    }
    
    func completeTransition() {
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
}
