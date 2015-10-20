//
//  Created by Artem Sidorenko on 9/11/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at https://github.com/Yalantis/StarWars.iOS
//

import UIKit

public class StarWarsUIDynamicAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    public var duration: NSTimeInterval = 2
    public var spriteWidth: CGFloat = 20

    var transitionContext: UIViewControllerContextTransitioning!

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    var animator: UIDynamicAnimator!
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()!
        let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view
        let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!.view
        
        containerView.addSubview(toView)
        containerView.sendSubviewToBack(toView)
        
        var snapshots:[UIView] = []
        let size = fromView.frame.size
        
        func randomFloatBetween(smallNumber: CGFloat, and bigNumber: CGFloat) -> CGFloat {
            let diff = bigNumber - smallNumber
            return CGFloat(arc4random()) / 100.0 % diff + smallNumber
        }
        
        // snapshot the from view, this makes subsequent snaphots more performant
        let fromViewSnapshot = fromView.snapshotViewAfterScreenUpdates(false)
        
        let width = spriteWidth
        let height = width
        
        animator = UIDynamicAnimator(referenceView: containerView)
        
        for x in CGFloat(0).stride(through: size.width, by: width) {
            for y in CGFloat(0).stride(through: size.height, by: height) {
                let snapshotRegion = CGRect(x: x, y: y, width: width, height: height)
                
                let snapshot = fromViewSnapshot.resizableSnapshotViewFromRect(snapshotRegion, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
                
                containerView.addSubview(snapshot)
                snapshot.frame = snapshotRegion
                snapshots.append(snapshot)
                
                let push = UIPushBehavior(items: [snapshot], mode: .Instantaneous)
                push.pushDirection = CGVector(dx: randomFloatBetween(-0.15 , and: 0.15), dy: randomFloatBetween(-0.15 , and: 0))
                push.active = true
                animator.addBehavior(push)
            }
        }
        let gravity = UIGravityBehavior(items: snapshots)
        animator.addBehavior(gravity)

        print(snapshots.count)
        
        fromView.removeFromSuperview()
        
        NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: "completeTransition", userInfo: nil, repeats: false)
        self.transitionContext = transitionContext
    }
    
    func completeTransition() {
        self.transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
    }
}
