//
//  IntroViewController.swift
//  StarWarsAnimations
//
//  Created by Artem Sidorenko on 9/11/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//

import UIKit
import StarWars

class IntroViewController: UIViewController {

    @IBOutlet
    private var topContraint: NSLayoutConstraint!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        topContraint.active = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(1, animations: {
            self.topContraint.active = true
            self.view.layoutIfNeeded()
        })        
    }
    
    @IBAction
    func backToIntroViewContoller(segue: UIStoryboardSegue) { }
    
    @IBAction func setupYourProfileTapped(sender: ProfileButton) {
        sender.animateTouchUpInside {
            self.performSegueWithIdentifier("presentSettings", sender: sender)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController
        destination.transitioningDelegate = self
        if let navigation = destination as? UINavigationController,
            settings = navigation.topViewController as? MainSettingsViewController {
                settings.theme = .light
        }
    }
}

extension IntroViewController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
//        return StarWarsUIDynamicAnimator()
//        return StarWarsUIViewAnimator()
        return StarWarsGLAnimator()
        
    }
}
