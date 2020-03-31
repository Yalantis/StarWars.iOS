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

    @IBOutlet fileprivate var topContraint: NSLayoutConstraint!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topContraint.isActive = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1) {
            self.topContraint.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func backToIntroViewContoller(_ segue: UIStoryboardSegue) { }
    
    @IBAction func setupYourProfileTapped(_ sender: ProfileButton) {
        sender.animateTouchUpInside {
            self.performSegue(withIdentifier: "presentSettings", sender: sender)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        destination.transitioningDelegate = self
        if let navigation = destination as? UINavigationController,
            let settings = navigation.topViewController as? MainSettingsViewController {
                settings.theme = .light
        }
    }
}

extension IntroViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        StarWarsUIDynamicAnimator()
//        StarWarsUIViewAnimator()
        StarWarsGLAnimator()
    }
}
