//
//  Created by Artem Sidorenko on 9/11/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at https://github.com/Yalantis/StarWars.iOS
//

import UIKit

open class StarWarsUIViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    open var duration: TimeInterval = 2
    open var spriteWidth: CGFloat = 10

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view
        
        containerView.addSubview(toView!)
        containerView.sendSubview(toBack: toView!)
        
        var snapshots:[UIView] = []
        let size = fromView?.frame.size
        
        func randomFloatBetween(_ smallNumber: CGFloat, and bigNumber: CGFloat) -> CGFloat {
            let diff = bigNumber - smallNumber
            return (CGFloat(arc4random()) / 100.0).truncatingRemainder(dividingBy: diff) + smallNumber
        }
        
        // snapshot the from view, this makes subsequent snaphots more performant
        let fromViewSnapshot = fromView?.snapshotView(afterScreenUpdates: false)
        
        let width = spriteWidth
        let height = width
        
        for x in stride(from: CGFloat(0), through: (size?.width)!, by: width) {
            for y in stride(from: CGFloat(0), through: (size?.height)!, by: height) {
                
                let snapshotRegion = CGRect(x: x, y: y, width: width, height: height)
                
                let snapshot = fromViewSnapshot!.resizableSnapshotView(from: snapshotRegion, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
                
                containerView.addSubview(snapshot!)
                snapshot!.frame = snapshotRegion
                snapshots.append(snapshot!)
            }
        }
    
        containerView.sendSubview(toBack: fromView!)
        
        UIView.animate(
            withDuration:
            duration,
            delay: 0,
            options: UIViewAnimationOptions.curveLinear,
            animations: {
                for view in snapshots {
                    let xOffset = randomFloatBetween(-200 , and: 200)
                    let yOffset = randomFloatBetween(fromView!.frame.height, and: fromView!.frame.height * 1.3)
                    view.frame = view.frame.offsetBy(dx: xOffset, dy: yOffset)
                }
            },
            completion: { _ in
                for view in snapshots {
                    view.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
