//
//  MainSettingsViewController.swift
//  StarWarsAnimations
//
//  Created by Artem Sidorenko on 10/19/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//

import UIKit

class MainSettingsViewController: UIViewController {

    @IBOutlet fileprivate weak var saveButton: UIButton!
    
    var theme: SettingsTheme! {
        didSet {
            settingsViewController?.theme = theme
            saveButton?.backgroundColor = theme.primaryColor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    fileprivate func setupNavigationBar() {
        navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.isTranslucent = true
        navigationController!.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "GothamPro", size: 20)!,
            NSForegroundColorAttributeName: UIColor.white
        ]
    }
    
    fileprivate var settingsViewController: SettingsViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settings = segue.destination as? SettingsViewController {
            settingsViewController = settings
            settings.themeChanged = { [unowned self, unowned settings] darkside, center in
                let center = self.view.convert(center, from: settings.view)
                self.view.animateCircularWithDuration(0.5, center: center, revert: darkside ? false : true, animations: {
                    self.theme = darkside ? .dark : .light
                })
            }
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
