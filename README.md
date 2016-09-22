# StarWars Animation
[![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](http://cocoapods.org/?q=YALSideMenu) [![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/Yalantis/Side-Menu.iOS/blob/master/LICENSE)

This component implements transition animation to crumble view-controller into tiny pieces.

[![Yalantis](https://raw.githubusercontent.com/Yalantis/PullToRefresh/develop/PullToRefreshDemo/Resources/badge_dark.png)](https://yalantis.com/?utm_source=github)

![Preview](preview.gif)

Check this <a href="https://dribbble.com/shots/2109991-Star-Wars-App-concept">project on dribbble</a>.

Also, read how it was done in [our blog](https://yalantis.com/blog/uidynamics-uikit-or-opengl-3-types-of-ios-animations-for-the-star-wars/)

## Requirements

- iOS 8.0+
- Xcode 9
- Swift 3

## Installing with [CocoaPods](https://cocoapods.org)

```ruby
use_frameworks!
pod 'StarWars', '~> 2.0'
```

## Usage

At first, import StarWars:

```swift
import StarWars
```

Then just implement class of *UIViewControllerTransitioningDelegate* that will return our animation form method *animationControllerForDismissedController* and assign it to *transitioningDelegate* of viewController that you want to dismiss.

```swift
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let destination = segue.destinationViewController
    destination.transitioningDelegate = self
}

func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return StarWarsGLAnimator()
}
```

There are also two things you can customize in the Star Wars animation: duration and sprite sizes. 
Let’s see how you can do this:

```swift
let animator = StarWarsGLAnimator()
animator.duration = 2
animator.spriteWidth = 8
```

Have fun! :)

#### Let us know!

We’d be really happy if you sent us links to your projects where you use our component. Just send an email to github@yalantis.com And do let us know if you have any questions or suggestion regarding the animation. 

P.S. We’re going to publish more awesomeness wrapped in code and a tutorial on how to make UI for iOS (Android) better than better. Stay tuned!

## License

	The MIT License (MIT)

	Copyright © 2015 Yalantis

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.

