//
//  Copyright © 2014 Yalantis
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//

import UIKit

open class AnimationDelegate: NSObject, CAAnimationDelegate {
    
    fileprivate let completion: () -> Void

    public init(completion: @escaping () -> Void) {
        self.completion = completion
    }

    public func animationDidStop(_: CAAnimation, finished: Bool) {
        completion()
    }
}
