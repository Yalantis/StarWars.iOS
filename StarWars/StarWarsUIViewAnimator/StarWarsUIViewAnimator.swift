//
//  Created by Artem Sidorenko on 9/11/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at https://github.com/Yalantis/StarWars.iOS
//

import UIKit

public class StarWarsUIViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    public var duration: NSTimeInterval = 2
    public var spriteWidth: CGFloat = 10


    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
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
        
        for x in CGFloat(0).stride(through: size.width, by: width) {
            for y in CGFloat(0).stride(through: size.height, by: height) {
                
                let snapshotRegion = CGRect(x: x, y: y, width: width, height: height)
                
                let snapshot = fromViewSnapshot.resizableSnapshotViewFromRect(snapshotRegion, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
                
                containerView.addSubview(snapshot)
                snapshot.frame = snapshotRegion
                snapshots.append(snapshot)
            }
        }
        
        print(snapshots.count)
        
        containerView.sendSubviewToBack(fromView)
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveLinear,  animations: {
            for view in snapshots {
                
                let xOffset: CGFloat = randomFloatBetween(-200 , and: 200)
                let yOffset: CGFloat = randomFloatBetween(fromView.frame.height, and: fromView.frame.height * 1.3)
                view.frame = view.frame.offsetBy(dx: xOffset, dy: yOffset)
            }
            }) { finished in
                for view in snapshots {
                    view.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }

}
