//
//  Copyright © 2014 Yalantis
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//

import UIKit

class AnimationDelegate: NSObject, CAAnimationDelegate {
    
    private let completion: () -> Void

    init(completion: () -> Void) {
        self.completion = completion
    }

    func animationDidStop(_: CAAnimation, finished: Bool) {
        completion()
    }
}
