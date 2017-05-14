//
//  TheEndViewController.swift
//  case_Studies
//
//  Created by Isabel  Lee on 09/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import UIKit
import StarWars

class TheEndViewController: UIViewController {
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var theEndButton: UIButton!
    @IBOutlet weak var theEnd: UILabel!
    
    @IBAction func theEndTapped(_ sender: UIButton) {
        self.view.animateCircular(withDuration: 1, center: self.view.center, revert: true, animations: {
            self.blackView.alpha = 1
            self.theEnd.text = "Thanks"
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
