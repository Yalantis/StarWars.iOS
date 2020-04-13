//
//  ViewController.swift
//  case_Studies
//
//  Created by Isabel  Lee on 02/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import UIKit
import StarWars

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {

    var speed = 3.0
    var size = 20.0
    var wind = 0.0
    var float = 0.25
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var floatLabel: UILabel!
    
    @IBOutlet weak var sizeStack: UIStackView!
    @IBOutlet weak var speedStack: UIStackView!
    @IBOutlet weak var windStack: UIStackView!
    @IBOutlet weak var floatStack: UIStackView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    let uiViewAnimator = StarWarsUIViewAnimator()
    let uiDynamicAnimator = StarWarsUIDynamicAnimator()
    let glaAnimator = StarWarsGLAnimator()
    let windAnimator = StarWarsWindAnimator()
    
    var currentAnimator: UIViewControllerAnimatedTransitioning!
    
    @IBAction func sizeSliderMoved(_ sender: UISlider) {
        let currentValue = Double(lroundf(sender.value))
        print("Size: \(currentValue)")
        sizeLabel.text = "\(currentValue)"
        size = currentValue
        uiViewAnimator.spriteWidth = CGFloat(size)
        uiDynamicAnimator.spriteWidth = CGFloat(size)
        windAnimator.spriteWidth = CGFloat(size)
    }
    
    @IBAction func speedSliderMoved(_ sender: UISlider) {
        let currentValue = round(sender.value * 10)/10
        print("Speed: \(currentValue)")
        speedLabel.text = String(format: "%.1f", currentValue)
        speed = Double(currentValue)
        uiViewAnimator.duration = speed
    }
    
    @IBAction func windSliderMoved(_ sender: UISlider) {
        let currentValue = sender.value
        windLabel.text = String(format: "%.1f", currentValue)
        wind = Double(currentValue)
        windAnimator.wind = CGFloat(wind)
    }
    
    
    @IBAction func floatSliderMoved(_ sender: UISlider) {
        let currentValue = sender.value
        floatLabel.text = String(format: "%.1f", currentValue)
        float = Double(currentValue)
        windAnimator.float = CGFloat(float)
    }

    @IBAction func changeAnimationSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.speedStack.isHidden = false
            self.windStack.isHidden = true
            self.floatStack.isHidden = true
            currentAnimator = uiViewAnimator
        
            return
        case 1:
            self.speedStack.isHidden = true
            self.windStack.isHidden = true
            self.floatStack.isHidden = true
            currentAnimator = uiDynamicAnimator
            return
        case 2:
            self.speedStack.isHidden = false
            self.windStack.isHidden = true
            self.floatStack.isHidden = true
            return
        case 3:
            self.speedStack.isHidden = true
            self.windStack.isHidden = false
            self.floatStack.isHidden = false
            currentAnimator = windAnimator
            return
        default:
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentAnimator = uiViewAnimator
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindToRoot(sender: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewTransitionSegue" {
            let destination = segue.destination
            destination.transitioningDelegate = self
        }
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return uiViewAnimator
        case 1:
            return uiDynamicAnimator
        case 2:
            let animator = StarWarsGLAnimator()
            animator.duration = speed
            animator.spriteWidth = CGFloat(size)

            return animator
        case 3:
            return windAnimator
        default:
            return uiViewAnimator
        }
    }
}


