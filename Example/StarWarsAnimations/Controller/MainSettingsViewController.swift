//
//  MainSettingsViewController.swift
//  StarWarsAnimations
//
//  Created by Artem Sidorenko on 10/19/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//

import UIKit

class MainSettingsViewController: UIViewController {

    @IBOutlet
    private weak var saveButton: UIButton!
    
    var theme: SettingsTheme! {
        didSet {
            settingsViewController?.theme = theme
            saveButton?.backgroundColor = theme.primaryColor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.translucent = true
        navigationController!.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "GothamPro", size: 20)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
    }
    
    private var settingsViewController: SettingsViewController!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let settings = segue.destinationViewController as? SettingsViewController {
            settingsViewController = settings
            settings.themeChanged = { [unowned self, unowned settings] darkside, center in
                let center = self.view.convertPoint(center, fromView: settings.view)
                self.view.animateCircularWithDuration(0.5, center: center, animations: {
                    self.theme = darkside ? .dark : .light
                })
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
